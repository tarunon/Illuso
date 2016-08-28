//
//  JSON.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

public enum JSON {
    case null
    case bool(Swift.Bool)
    case string(Swift.String)
    case number(Illuso.Number)
    case array([JSON])
    case dictionary([Swift.String: JSON])
    
    public func asObject() -> AnyObject {
        switch self {
        case .null:
            return NSNull()
        case .bool(let bool):
            return NSNumber(value: bool)
        case .string(let string):
            return NSString(string: string)
        case .number(let number):
            return number.asObject()
        case .array(let array):
            return NSArray(array: array.map { $0.asObject() })
        case .dictionary(let dictionary):
            return NSDictionary(dictionary: convert(dictionary.map { ($0, $1.asObject()) }))
        }
    }
    
    internal func isNested() -> Swift.Bool {
        switch self {
        case .array(_), .dictionary(_):
            return true
        default:
            return false
        }
    }
    
    public func stringify(prettyPrinted: Swift.Bool = false) throws -> Swift.String {
        guard self.isNested() else {
            throw JSONError.incorrectTopLebel(self)
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: self.asObject(), options: prettyPrinted ? .prettyPrinted : [])
            if let string = String(data: data, encoding: .utf8) {
                return string
            }
            throw JSONError.failedDecoding(data)
        } catch {
            throw JSONError.failedStringify(error)
        }
    }

}
