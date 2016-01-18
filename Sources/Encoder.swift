//
//  Encoder.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

internal func convert<T>(array: [(String, T)]) -> [String: T] {
    var dict = [String: T]()
    array.forEach { key, value in
        dict[key] = value
    }
    return dict
}

internal func map(elements: Mirror.Children) throws -> [JSON] {
    return try elements
        .flatMap { key, value in
            try _encode(value)
    }
}

internal func map(pairs: Mirror.Children) throws -> [String: JSON] {
    return convert(try pairs
        .map { key, value -> (String, JSON) in
            guard case .ARRAY(let pair) = try _encode(value) else { throw JSONError.Unknown }
            guard let key = pair[0].asObject() as? String else { throw JSONError.KeyIsNotString(pair[0].asObject()) }
            return (key, pair[1])
        })
}

internal func analyze(mirror: Mirror) throws -> [(String, JSON)] {
    let superclassProperties = try mirror.superclassMirror().map { try analyze($0) } ?? []
    let properties = try mirror.children
        .flatMap { key, value in
            key.map { ($0, value) }
        }
        .map { key, value in
            try (key, _encode(value))
        }
    return superclassProperties + properties
}

internal func _encode(object: Any?) throws -> JSON {
    guard let object = object else {
        return .NULL
    }
    if let json = object as? JSON {
        return json
    }
    if let encodable = object as? Encodable {
        return try encodable.encode()
    }
    let mirror = Mirror(reflecting: object)
    if let displayType = mirror.displayStyle {
        switch displayType {
        case .Struct, .Class:
            return .DICTIONARY(convert(try analyze(mirror)))
        case .Collection, .Set, .Tuple:
            return .ARRAY(try map(mirror.children))
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
