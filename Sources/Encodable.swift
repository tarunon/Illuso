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
    public func encode(_ object: Any?) throws -> JSON {
        return try _encode(object)
    }

    // workaround: Escape swift compiler warnigns: `Expression implicitly coerced from 'String?' to Any`
    public func encode(dictionary: [String: Any?]) throws -> JSON {
        return try _encode(dictionary)
    }
}

extension String: Encodable {
    public func encode() throws -> JSON {
        return .string(self)
    }
}

extension Bool: Encodable {
    public func encode() throws -> JSON {
        return .bool(self)
    }
}

public protocol Number: Encodable {
    
}

extension Number {
    public func encode() throws -> JSON {
        return .number(self)
    }
}

extension Int: Number {

}

extension UInt: Number {

}

extension Float: Number {

}

extension Double: Number {

}

extension Int8: Number {

}

extension Int16: Number  {

}

extension Int32: Number  {

}

extension Int64: Number  {

}

extension UInt8: Number {

}

extension UInt16: Number {

}

extension UInt32: Number {

}

extension UInt64: Number {

}

extension ImplicitlyUnwrappedOptional: Encodable {
    public func encode() throws -> JSON {
        switch self {
        case .none:
            return JSON.null
        case .some(let value):
            return try _encode(value)
        }
    }
}

extension NSString: Encodable {
    public func encode() throws -> JSON {
        return .string(self as String)
    }
}

extension NSNumber: Number {}
