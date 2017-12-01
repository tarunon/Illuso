//
//  EncoderTests.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/08.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import XCTest
@testable import Illuso

private extension Dictionary {
    func isEqual(to rhs: [Key: Value]) -> Bool {
        return NSDictionary(dictionary: self).isEqual(to: rhs)
    }
}

struct SampleNestedEncodableObject: Swift.Encodable {
    let nestedObject: SampleEncodableObject
}

extension SampleNestedEncodableObject: Illuso.Encodable { }

struct SampleEncodableObject: Swift.Encodable {
    let floatValue: Float
    let stringValue: String
    let intValue: Int
}

extension SampleEncodableObject: Illuso.Encodable { }

class EncoderTests: XCTestCase {
    
    func testEncodeEncodableToDictionary() {
        let object = SampleEncodableObject(floatValue: 1.0, stringValue: "2", intValue: 3)
        let expectedDict: [String: Any] = ["floatValue": 1.0, "stringValue": "2", "intValue": 3]
        let actualDict = try! object.encodeToDictionary()
        
        XCTAssertTrue(expectedDict.isEqual(to: actualDict))
        
        XCTAssertEqual(actualDict["floatValue"] as? Float, 1.0)
        XCTAssertEqual(actualDict["stringValue"] as? String, "2")
        XCTAssertEqual(actualDict["intValue"] as? Float, 3)
    }
    
    func testEncodeEncodableToJSON() {
        let object = SampleEncodableObject(floatValue: 1.0, stringValue: "2", intValue: 3)
        let json = try! encode(object).asObject() as! [String: Any]
        
        XCTAssertEqual(json["floatValue"] as? Float, 1.0)
        XCTAssertEqual(json["intValue"] as? Int, 3)
        XCTAssertEqual(json["stringValue"] as? String, "2")
    }
    
    func testNestedEncodeEncodableToJSON() {
        let nestedObject = SampleEncodableObject(floatValue: 1.0, stringValue: "2", intValue: 3)
        let object = SampleNestedEncodableObject(nestedObject: nestedObject)
        let parentJson = try! encode(object).asObject() as! [String: Any]
        let json = parentJson["nestedObject"] as! [String: Any]
        
        XCTAssertEqual(json["floatValue"] as? Float, 1.0)
        XCTAssertEqual(json["intValue"] as? Int, 3)
        XCTAssertEqual(json["stringValue"] as? String, "2")
    }
    
    func testEncodeJsonObject() {
        let object = SampleEncodableObject(floatValue: 1.0, stringValue: "2", intValue: 3)
        let jsonObjectData = try! JSONEncoder().encode(object)
        let jsonObject = try! JSONSerialization.jsonObject(with: jsonObjectData, options: .allowFragments)
        let json = try! encode(jsonObject).asObject() as! [String: Any]
        XCTAssertEqual(json["floatValue"] as? Float, 1.0)
        XCTAssertEqual(json["intValue"] as? Int, 3)
        XCTAssertEqual(json["stringValue"] as? String, "2")
    }
    
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
            XCTAssertEqual(Int8(json["int8"] as! Int8), object.int8)
            XCTAssertEqual(Int16(json["int16"] as! Int16), object.int16)
            XCTAssertEqual(Int32(json["int32"] as! Int32), object.int32)
            XCTAssertEqual(Int64(json["int64"] as! Int64), object.int64)
            XCTAssertEqual(json["uint"] as? UInt, object.uint)
            XCTAssertEqual(UInt8(json["uint8"] as! UInt8), object.uint8)
            XCTAssertEqual(UInt16(json["uint16"] as! UInt16), object.uint16)
            XCTAssertEqual(UInt32(json["uint32"] as! UInt32), object.uint32)
            XCTAssertEqual(UInt64(json["uint64"] as! UInt64), object.uint64)
            XCTAssertEqual(json["float"] as? Float, object.float)
            XCTAssertEqual(json["double"] as? Double, object.double)
            XCTAssertEqual(json["array"] as! [Int], object.array)
            XCTAssertEqual(json["anyArray"] as? NSArray, NSArray(array: object.anyArray))
            XCTAssertEqual(json["dictionary"] as! [String: Int], object.dictionary)
            XCTAssertEqual(json["tuple"] as! [Int], [object.tuple.0, object.tuple.1, object.tuple.2])
            XCTAssertEqual(json["optional"] as? Int, object.optional)
            XCTAssertEqual(json["implicitlyUnwrappedOptional"] as? Int, object.implicitlyUnwrappedOptional)
            let enumValues = (json["_enum"] as? NSDictionary)?["a"] as? NSArray
            XCTAssertEqual(enumValues?[0] as? Int, 123)
            XCTAssertEqual(enumValues?[1] as? String, "abc")
            XCTAssertEqual(enumValues?[2] as? Float, 1.1)
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
    
    static var allTests : [(String, (EncoderTests) -> () throws -> Void)] {
        return [
            ("testStandardEncodable", testStandardEncodable),
            ("testCustomEncodable", testCustomEncodable),
            ("testSubclassEncode", testSubclassEncode),
            ("testRawRepresentable", testRawRepresentable),
            ("testStringify", testStringify),
            ("testFailureKeyIsNotString", testFailureKeyIsNotString)
        ]
    }
}
