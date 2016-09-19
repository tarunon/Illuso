//
//  Encoder.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

internal func convert<T>(_ array: [(String, T)]) -> [String: T] {
    var dict = [String: T]()
    array.forEach { key, value in
        dict[key] = value
    }
    return dict
}

internal func map(_ elements: Mirror.Children) throws -> [JSON] {
    return try elements
        .flatMap { key, value in
            try _encode(value)
    }
}

internal func map(_ pairs: Mirror.Children) throws -> [String: JSON] {
    return convert(try pairs
        .map { key, value -> (String, JSON) in
            guard case .array(let pair) = try _encode(value) else { throw JSONError.unknown }
            guard let key = pair[0].asObject() as? String else { throw JSONError.keyIsNotString(pair[0].asObject()) }
            return (key, pair[1])
        })
}

internal func analyze(_ mirror: Mirror) throws -> [(String, JSON)] {
    let superclassProperties = try mirror.superclassMirror.map { try analyze($0) } ?? []
    let properties = try mirror.children
        .flatMap { key, value in
            key.map { ($0, value) }
        }
        .map { key, value in
            try (key, _encode(value))
        }
    return superclassProperties + properties
}

internal func _encode(_ object: Any?) throws -> JSON {
    guard let object = object else {
        return .null
    }
    if let json = object as? JSON {
        return json
    }
    if let encodable = object as? Encodable {
        return try encodable.encode()
    }
    let mirror = Mirror(reflecting: object)
    switch mirror.displayStyle {
    case .some(.struct), .some(.class), .some(.enum):
        return .dictionary(convert(try analyze(mirror)))
    case .some(.collection), .some(.set), .some(.tuple):
        return .array(try map(mirror.children))
    case .some(.dictionary):
        return .dictionary(try map(mirror.children))
    case .some(.optional):
        if let some = mirror.children.first {
            return try _encode(some.value)
        }
        return .null
    default:
        break
    }
    throw JSONError.unsupportedType(object)
}

// workaround: We cannot overload class method and global function.
public func encode(_ object: Any?) throws -> JSON {
    return try _encode(object)
}
