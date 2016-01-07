//
//  Encodable.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

public protocol Encodable {
    func toJSON() -> JSON
}

public protocol Number: Encodable {}

extension String: Encodable {
    public func toJSON() -> JSON {
        return .STRING(self)
    }
}

extension Number {
    public func toJSON() -> JSON {
        return .NUMBER(self as! NSNumber)
    }
}

extension Bool: Number {}
extension Int: Number {}
extension Int8: Number {}
extension Int16: Number {}
extension Int32: Number {}
extension Int64: Number {}
extension UInt: Number {}
extension UInt8: Number {}
extension UInt16: Number {}
extension UInt32: Number {}
extension UInt64: Number {}
extension Float: Number {}
extension Double: Number {}
