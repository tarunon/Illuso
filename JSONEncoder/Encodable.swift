//
//  Encodable.swift
//  JSONEncoder
//
//  Created by Nobuo Saito on 2016/01/07.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

protocol Encodable {
    func toJSON() -> BasicEncodable?
}

protocol BasicEncodable: Encodable {}

extension BasicEncodable {
    func toJSON() -> BasicEncodable? {
        return self
    }
}

extension NSString: BasicEncodable {}
extension NSNumber: BasicEncodable {}
extension NSNull: BasicEncodable {}

extension Bool: BasicEncodable {}
extension Int: BasicEncodable {}
extension Int8: BasicEncodable {}
extension Int16: BasicEncodable {}
extension Int32: BasicEncodable {}
extension Int64: BasicEncodable {}
extension Float: BasicEncodable {}
extension Double: BasicEncodable {}
extension String: BasicEncodable {}
