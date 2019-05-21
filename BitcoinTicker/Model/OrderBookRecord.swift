//
//  OrderBookRecord.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 20/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import Foundation

enum OBRecordType {
    case buy, sell
}

struct OrderBookRecord : Codable {
    let price: Double
    let count: Int
    let amount: Double
    
    func getRecordType() -> OBRecordType {
        return (amount < 0) ? .sell : .buy
    }
}
