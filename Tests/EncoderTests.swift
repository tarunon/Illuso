//
//  EncoderTests.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/08.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import XCTest
@testable import Illuso

class EncoderTests: XCTestCase {
    
    func testStandardEncodable() {
        do {
            let object = StandardEncodables()
            guard case .DICTIONARY(let json) = try encode(object) else {
                XCTFail()
                return
            }
            XCTAssert(json["null"]!.isKindOfClass(NSNull.self))
            XCTAssertEqual(json["string"] as? String, object.string)
            XCTAssertEqual(json["nsstring"] as? NSString, object.nsstring)
            XCTAssertEqual(json["bool"] as? Bool, object.bool)
            XCTAssertEqual(json["nsnumber"] as? NSNumber, object.nsnumber)
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
//            XCTAssertEqual(json["float80"] as? Float, Float(object.float80))
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
            
            guard case .STRING(let string) = try encode(object) else {
                XCTFail()
                return
            }
            XCTAssertEqual(string, object.customValue())

            guard case .ARRAY(let array) = try encode([object]) else {
                XCTFail()
                return
            }
            XCTAssertEqual(array, [object.customValue()])

            guard case .DICTIONARY(let dictionary) = try encode(["value": object]) else {
                XCTFail()
                return
            }
            XCTAssertEqual(dictionary, ["value": object.customValue()])
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
        } catch JSONError.UnsupportedType(let value) {
            XCTAssertEqual(url, value as? NSURL)
        } catch {
            XCTFail()
        }
    }
    
    func testFailureKeyIsNotString() {
        let dictionary = [1: 2]
        do {
            _ = try encode(dictionary)
        } catch JSONError.KeyIsNotString(let key) {
            XCTAssertEqual(1, key as? Int)
        } catch {
            XCTFail()
        }
    }
}
