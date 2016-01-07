//
//  Encoder.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

private func convert<T>(array: [(String, T)]) -> [String: T] {
    var dict = [String: T]()
    array.forEach { key, value in
        dict[key] = value
    }
    return dict
}

private func mapArray(elements: Mirror.Children) throws -> [AnyObject] {
    return try elements
        .flatMap { key, value in
            try encode(value).asObject()
    }
}

private func map(pairs: Mirror.Children) throws -> [String: AnyObject] {
    return convert(try pairs
        .map { key, value -> (String, AnyObject) in
            guard case .ARRAY(let pair) = try encode(value) else { throw JSONError.Unknown }
            return (pair[0] as! String, pair[1])
        })
}

private func analisys(properties: Mirror.Children) throws -> [String: AnyObject] {
    return convert(try properties
        .flatMap { key, value in
            key.map { ($0, value) }
        }
        .map { key, value in
            try (key, encode(value).asObject())
        })
}

public func encode(object: Any?) throws -> JSON {
    guard let object = object else {
        return .NULL
    }
    if let encodable = object as? Encodable {
        let encoded = encodable.toJSON()
        if encoded.isNested() {
            return try encode(encoded.asObject())
        } else {
            return encoded
        }
    }
    let mirror = Mirror(reflecting: object)
    if let displayType = mirror.displayStyle {
        switch displayType {
        case .Struct, .Class:
            return .DICTIONARY(try analisys(mirror.children))
        case .Collection, .Set, .Tuple:
            return .ARRAY(try mapArray(mirror.children))
        case .Dictionary:
            return .DICTIONARY(try map(mirror.children))
        case .Optional:
            if let some = mirror.children.first {
                return try encode(some.value)
            }
            return .NULL
        default:
            break
        }
    }
    throw JSONError.UnsupportedType(object)
}
