//
//  Encodable.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

public protocol Encodable {
    func encode() throws -> JSON
}

extension Encodable {
    // workaround: We cannot overload class method and global function.
    public func encode(object: Any?) throws -> JSON {
        return try _encode(object)
    }
}

extension String: Encodable {
    public func encode() throws -> JSON {
        return .STRING(self)
    }
}

extension NSString: Encodable {
    public func encode() throws -> JSON {
        return .STRING(self as String)
    }
}

extension Bool: Encodable {
    public func encode() throws -> JSON {
        return .BOOL(self)
    }
}

public protocol Number: Encodable {}

extension Number {
    public func encode() throws -> JSON {
        if let number = self as? NSNumber {
            return .NUMBER(number)
        } else {
            throw JSONError.UnsupportedType(self)
        }
    }
}

extension Int: Number {}
extension UInt: Number {}
extension Float: Number {}
extension Double: Number {}
extension NSNumber: Number {}

extension Int8: Number {
    public func encode() throws -> JSON {
        return .NUMBER(NSNumber(integer: Int(self)))
    }
}

extension Int16: Number  {
    public func encode() throws -> JSON {
        return .NUMBER(NSNumber(integer: Int(self)))
    }
}

extension Int32: Number  {
    public func encode() throws -> JSON {
        return .NUMBER(NSNumber(integer: Int(self)))
    }
}

extension Int64: Number  {
    public func encode() throws -> JSON {
        return .NUMBER(NSNumber(integer: Int(self)))
    }
}

extension UInt8: Number {
    public func encode() throws -> JSON {
        return .NUMBER(NSNumber(unsignedLong: UInt(self)))
    }
}

extension UInt16: Number {
    public func encode() throws -> JSON {
        return .NUMBER(NSNumber(unsignedLong: UInt(self)))
    }
}

extension UInt32: Number {
    public func encode() throws -> JSON {
        return .NUMBER(NSNumber(unsignedLong: UInt(self)))
    }
}

extension UInt64: Number {
    public func encode() throws -> JSON {
        return .NUMBER(NSNumber(unsignedLong: UInt(self)))
    }
}

//extension Float80: Number {
//    public func encode() throws -> JSON {
//        return .NUMBER(NSNumber(float: Float(self)))
//    }
//}
