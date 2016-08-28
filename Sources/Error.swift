//
//  Error.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

public enum JSONError: Error {
    case unsupportedType(Any)
    case incorrectTopLebel(JSON)
    case failedDecoding(Data)
    case failedStringify(Error)
    case keyIsNotString(Any)
    case unknown
}
