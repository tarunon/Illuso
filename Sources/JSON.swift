//
//  JSON.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

public enum JSON {
    case null
    case bool(Bool)
    case string(String)
    case number(Number)
    case array([JSON])
    case dictionary([String: JSON])
    
    public func asObject() -> AnyObject {
        switch self {
        case .null:
            return Any?.none as AnyObject
        case .bool(let bool):
            return bool as AnyObject
        case .string(let string):
            return string as AnyObject
        case .number(let number):
            return number as AnyObject
        case .array(let array):
            return array.map { $0.asObject() } as AnyObject
        case .dictionary(let dictionary):
            return convert(dictionary.map { ($0, $1.asObject()) }) as AnyObject
        }
    }
    
    internal func isNested() -> Bool {
        switch self {
        case .array(_), .dictionary(_):
            return true
        default:
            return false
        }
    }
}

import Foundation

public extension JSON {
    public func stringify(prettyPrinted: Bool = false) throws -> String {
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
