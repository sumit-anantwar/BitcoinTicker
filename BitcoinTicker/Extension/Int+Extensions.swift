//
//  Int+Extensions.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 22/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import Foundation

extension Int {
    
    func toString() -> String {
        return String(self)
    }
    
}

extension Double {
    
    func absolute() -> Double {
        return abs(self)
    }
    
    func twoDecimalString() -> String {
        return self.toString(precision: 2)
    }
    
    func toString(precision: Int) -> String {
        return String(format: "%.\(precision)f", self)
    }
}
