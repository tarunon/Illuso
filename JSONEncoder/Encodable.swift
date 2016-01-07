//
//  Encodable.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

public protocol Encodable {
    func toJSON() -> BasicEncodable?
}

public protocol BasicEncodable: Encodable {}

public extension BasicEncodable {
    func toJSON() -> BasicEncodable? {
        return self
    }
}

extension Bool: BasicEncodable {}
extension Int: BasicEncodable {}
extension Int8: BasicEncodable {}
extension Int16: BasicEncodable {}
extension Int32: BasicEncodable {}
extension Int64: BasicEncodable {}
extension Float: BasicEncodable {}
extension Double: BasicEncodable {}
extension String: BasicEncodable {}

// workaround: We cannnot define extension typed Array or Dictionary.
extension Array: BasicEncodable {}
extension Dictionary: BasicEncodable {}

internal extension Encodable {
    func isNested() -> Bool {
        let mirror = Mirror(reflecting: self)
        return mirror.displayStyle == .Dictionary || mirror.displayStyle == .Collection
    }
}
