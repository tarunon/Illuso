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

private func mapArray(properties: Mirror.Children) throws -> [AnyObject] {
    return try properties
        .flatMap { key, value in
            try encode(value)
    }
}

private func map(properties: Mirror.Children) throws -> [String: AnyObject] {
    return convert(try properties
        .map { key, value -> (String, AnyObject) in
            let pair = try encode(value) as! [AnyObject]
            return (pair[0] as! String, pair[1])
        })
}

private func encode(properties: Mirror.Children) throws -> [String: AnyObject] {
    return convert(try properties
        .flatMap { key, value in
            key.map { ($0, value) }
        }
        .map { key, value in
            try (key, encode(value))
        })
}

public func encode(object: Any?) throws -> AnyObject {
    guard let object = object else {
        return NSNull()
    }
    if let object = object as? Encodable {
        return object.toJSON() as? AnyObject ?? NSNull()
    }
    let mirror = Mirror(reflecting: object)
    if let displayType = mirror.displayStyle {
        switch displayType {
        case .Struct, .Class:
            return try encode(mirror.children)
        case .Collection, .Set, .Tuple:
            return try mapArray(mirror.children)
        case .Dictionary:
            return try map(mirror.children)
        case .Optional:
            if let value = mirror.children.first {
                return try encode(value.value)
            }
            return NSNull()
        default:
            break
        }
    }
    throw JSONError.UnsupportedType(object)
}

public func stringify(obj: Any?, prettyPrinted: Bool) throws -> String {
    let json = try encode(obj)
    guard json is [AnyObject] || json is [String: AnyObject] else {
        throw JSONError.IncorrectTopLebel(json)
    }
    do {
        let data = try NSJSONSerialization.dataWithJSONObject(json, options: prettyPrinted ? .PrettyPrinted : [])
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {
            return string
        }
        throw JSONError.FailedDecoding(data)
    } catch {
        throw JSONError.FailedStringify(error)
    }
}
