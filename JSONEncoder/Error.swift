//
//  Error.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

public enum JSONError: ErrorType {
    case UnsupportedType(Any)
    case IncorrectTopLebel(JSON)
    case FailedDecoding(NSData)
    case FailedStringify(ErrorType)
    case KeyIsNotString(Any)
    case Unknown
}