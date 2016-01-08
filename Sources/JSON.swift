//
//  JSON.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

public enum JSON {
    case NULL
    case BOOL(Bool)
    case STRING(String)
    case NUMBER(Number)
    case ARRAY([AnyObject])
    case DICTIONARY([String: AnyObject])
    
    public func asObject() -> AnyObject {
        switch self {
        case .NULL:
            return NSNull()
        case .BOOL(let bool):
            return bool
        case .STRING(let string):
            return string
        case .NUMBER(let number):
            return number.asObject()
        case .ARRAY(let array):
            return array
        case .DICTIONARY(let dictionary):
            return dictionary
        }
    }
    
    internal func isNested() -> Bool {
        switch self {
        case .ARRAY(_), .DICTIONARY(_):
            return true
        default:
            return false
        }
    }
    
    public func stringify(prettyPrinted: Bool = false) throws -> String {
        guard self.isNested() else {
            throw JSONError.IncorrectTopLebel(self)
        }
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(self.asObject(), options: prettyPrinted ? .PrettyPrinted : [])
            if let string = String(data: data, encoding: NSUTF8StringEncoding) {
                return string
            }
            throw JSONError.FailedDecoding(data)
        } catch {
            throw JSONError.FailedStringify(error)
        }
    }

}