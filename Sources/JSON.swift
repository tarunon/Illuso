//
//  JSON.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

public enum JSON {
    case Null
    case Bool(Swift.Bool)
    case String(Swift.String)
    case Number(Illuso.Number)
    case Array([JSON])
    case Dictionary([Swift.String: JSON])
    
    public func asObject() -> AnyObject {
        switch self {
        case .Null:
            return NSNull()
        case .Bool(let bool):
            return bool
        case .String(let string):
            return string
        case .Number(let number):
            return number.asObject()
        case .Array(let array):
            return array.map { $0.asObject() }
        case .Dictionary(let dictionary):
            return convert(dictionary.map { ($0, $1.asObject()) })
        }
    }
    
    internal func isNested() -> Swift.Bool {
        switch self {
        case .Array(_), .Dictionary(_):
            return true
        default:
            return false
        }
    }
    
    public func stringify(prettyPrinted: Swift.Bool = false) throws -> Swift.String {
        guard self.isNested() else {
            throw JSONError.IncorrectTopLebel(self)
        }
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(self.asObject(), options: prettyPrinted ? .PrettyPrinted : [])
            if let string = Swift.String(data: data, encoding: NSUTF8StringEncoding) {
                return string
            }
            throw JSONError.FailedDecoding(data)
        } catch {
            throw JSONError.FailedStringify(error)
        }
    }

}