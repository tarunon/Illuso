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
            try _encode(value).asObject()
    }
}

private func map(pairs: Mirror.Children) throws -> [String: AnyObject] {
    return convert(try pairs
        .map { key, value -> (String, AnyObject) in
            guard case .ARRAY(let pair) = try _encode(value) else { throw JSONError.Unknown }
            return (pair[0] as! String, pair[1])
        })
}

private func analisys(properties: Mirror.Children) throws -> [String: AnyObject] {
    return convert(try properties
        .flatMap { key, value in
            key.map { ($0, value) }
        }
        .map { key, value in
            try (key, _encode(value).asObject())
        })
}

internal func _encode(object: Any?) throws -> JSON {
    guard let object = object else {
        return .NULL
    }
    if let encodable = object as? Encodable {
        return try encodable.encode()
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
                return try _encode(some.value)
            }
            return .NULL
        default:
            break
        }
    }
    throw JSONError.UnsupportedType(object)
}

// workaround: We cannot overload class method and global function.
public func encode(object: Any?) throws -> JSON {
    return try _encode(object)
}
