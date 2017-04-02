//
//  RawRepresentable.swift
//  Illuso
//
//  Created by Nobuo Saito on 2016/01/29.
//  Copyright © 2016年 tarunon. All rights reserved.
//

//import Foundation

public extension RawRepresentable where Self: Encodable {
    func encode() throws -> JSON {
        return try encode(self.rawValue)
    }
}
