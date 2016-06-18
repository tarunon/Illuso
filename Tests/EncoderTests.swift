//
//  EncoderTests.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/08.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import XCTest
import Illuso

class EncoderTests: XCTestCase {
    
    func testStandardEncodable() {
        do {
            let object = StandardEncodables()
            guard let json = try encode(object).asObject() as? [String: AnyObject] else {
                XCTFail()
                return
            }
            XCTAssert(json["null"]!.isKind(of: (NSNull.self)))
            XCTAssertEqual(json["string"] as? String, object.string)
            XCTAssertEqual(json["bool"] as? Bool, object.bool)
            XCTAssertEqual(json["int"] as? Int, object.int)
            XCTAssertEqual(Int8(json["int8"] as! Int), object.int8)
            XCTAssertEqual(Int16(json["int16"] as! Int), object.int16)
            XCTAssertEqual(Int32(json["int32"] as! Int), object.int32)
            XCTAssertEqual(Int64(json["int64"] as! Int), object.int64)
            XCTAssertEqual(json["uint"] as? UInt, object.uint)
            XCTAssertEqual(UInt8(json["uint8"] as! UInt), object.uint8)
            XCTAssertEqual(UInt16(json["uint16"] as! UInt), object.uint16)
            XCTAssertEqual(UInt32(json["uint32"] as! UInt), object.uint32)
            XCTAssertEqual(UInt64(json["uint64"] as! UInt), object.uint64)
            XCTAssertEqual(json["float"] as? Float, object.float)
            XCTAssertEqual(json["double"] as? Double, object.double)
            XCTAssertEqual(json["array"] as! [Int], object.array)
            XCTAssertEqual(json["anyArray"] as? NSArray, object.anyArray.map { $0 as! AnyObject })
            XCTAssertEqual(json["dictionary"] as! [String: Int], object.dictionary)
            XCTAssertEqual(json["tuple"] as! [Int], [object.tuple.0, object.tuple.1, object.tuple.2])
            XCTAssertEqual(json["optional"] as? Int, object.optional)
            XCTAssertEqual(json["implicitlyUnwrappedOptional"] as? Int, object.implicitlyUnwrappedOptional)
        } catch {
            XCTFail()
        }
    }
    
    func testCustomEncodable() {
        do {
            let object = CustomEncodable()
            
            guard case .string(let string) = try encode(object) else {
                XCTFail()
                return
            }
            XCTAssertEqual(string, object.customValue())

            guard let array = try encode([object]).asObject() as? [AnyObject] else {
                XCTFail()
                return
            }
            XCTAssertEqual(array as! [String], [object.customValue()])

            guard let dictionary = try encode(["value": object]).asObject() as? [String: AnyObject] else {
                XCTFail()
                return
            }
            XCTAssertEqual(dictionary as! [String: String], ["value": object.customValue()])
        } catch {
            XCTFail()
        }
    }
    
    func testSubclassEncode() {
        do {
            let object = SubclassEncodables()
            guard let json = try encode(object).asObject() as? [String: AnyObject] else {
                XCTFail()
                return
            }
            XCTAssertEqual(json["classValue"] as? String, object.classValue)
            XCTAssertEqual(json["subclassValue"] as? Int, object.subclassValue)
        } catch {
            XCTFail()
        }
    }
    
    func testRawRepresentable() {
        do {
            let value = EncodableRawRepresentable.EncodableCase
            guard let number = try encode(value).asObject() as? Int else {
                XCTFail()
                return
            }
            XCTAssertEqual(number, value.rawValue)
        } catch {
            XCTFail()
        }
    }
    
    func testStringify() {
        do {
            let object = [1, 2, 3]
            let string = try encode(object).stringify()
            
            XCTAssertEqual(string, "[1,2,3]")
        } catch {
            XCTFail()
        }
    }
    
    func testFailureUnsupportedType() {
        let url = NSURL(string: "http://a.b")
        do {
            _ = try encode(url)
            XCTFail()
        } catch JSONError.unsupportedType(let value) {
            XCTAssertEqual(url, value as? NSURL)
        } catch {
            XCTFail()
        }
    }
    
    func testFailureKeyIsNotString() {
        let dictionary = [1: 2]
        do {
            _ = try encode(dictionary)
        } catch JSONError.keyIsNotString(let key) {
            XCTAssertEqual(1, key as? Int)
        } catch {
            XCTFail()
        }
    }
}
