//
//  Model.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/08.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation
@testable import Illuso

struct StandardEncodables {
    let null: Any? = nil
    let string: String = "abc"
    let bool: Bool = true
    let int: Int = 123
    let int8: Int8 = 123
    let int16: Int16 = 123
    let int32: Int32 = 123
    let int64: Int64 = 123
    let uint: UInt = 123
    let uint8: UInt8 = 123
    let uint16: UInt16 = 123
    let uint32: UInt32 = 123
    let uint64: UInt64 = 123
    let float: Float = 1.1
    let double: Double = 1.1
    let array: [Int] = [1, 2, 3]
    let anyArray: [Any] = [true, 2, "3"]
    let dictionary: [String: Int] = ["a": 1, "b": 2, "c": 3]
    let tuple: (Int, Int, Int) = (1, 2, 3)
    let optional: Int? = 123
    let implicitlyUnwrappedOptional: Int! = 123
}

struct CustomEncodable: Encodable {
    let value = 0
    
    func customValue() -> String {
        return "value is \(value)"
    }
    
    func encode() throws -> JSON {
        return try encode(self.customValue())
    }
}

class ClassEncodables {
    let classValue: String = "abc"
}

class SubclassEncodables: ClassEncodables {
    let subclassValue: Int = 123
}

enum EncodableRawRepresentable: Int, Encodable {
    case EncodableCase
}
