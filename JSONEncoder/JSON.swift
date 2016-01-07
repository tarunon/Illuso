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
    case STRING(NSString)
    case NUMBER(NSNumber)
    case ARRAY(NSArray)
    case DICTIONARY(NSDictionary)
    
    init(object: AnyObject) throws {
        switch object {
        case is String:
            self = .STRING(object as! String)
        case is Number:
            self = .NUMBER(object as! NSNumber)
        case is NSArray:
            self = .ARRAY(object as! NSArray)
        case is NSDictionary:
            self = .DICTIONARY(object as! NSDictionary)
        default:
            throw JSONError.UnsupportedType(object)
        }
    }
    
    public func asObject() -> AnyObject {
        switch self {
        case .NULL:
            return NSNull()
        case .STRING(let string):
            return string
        case .NUMBER(let number):
            return number
        case .ARRAY(let array):
            return array
        case .DICTIONARY(let dictionary):
            return dictionary
        }
    }
    
    internal func isNested() -> Bool {
        if case .ARRAY(_) = self {
            return true
        } else if case .DICTIONARY(_) = self {
            return true
        } else {
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