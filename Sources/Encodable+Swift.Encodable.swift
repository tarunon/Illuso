//
//  Encodable+Swift.Encodable.swift
//  Illuso
//
//  Created by ST20591 on 2017/11/14.
//

import Foundation

public extension Swift.Encodable {
    func encodeToDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let dictionary = jsonObject as? [String: Any] else {
            throw JSONError.unknown
        }
        return dictionary
    }
}

public extension Illuso.Encodable where Self: Swift.Encodable {
    func encode() throws -> JSON {
        return try encode(encodeToDictionary())
    }
}

