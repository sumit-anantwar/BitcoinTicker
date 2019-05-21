//
//  Codable+Extensions.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 22/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import Foundation

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

extension Dictionary {
    
    func toJSONString() -> String? {
        
        if let json = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
           let string = String(data: json, encoding: .utf8) {
            return string
        }
        
        return nil
    }
}
