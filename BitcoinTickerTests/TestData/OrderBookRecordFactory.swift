//
//  OrderBookRecordFactory.swift
//  SwissBorgTechTestTests
//
//  Created by Sumit Anantwar on 21/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import Foundation

@testable import BitcoinTicker

class OrderBookRecordFactory {
    
    static func generateOrderBookRecords(quantity: Int) -> [OrderBookRecord] {
        var records: [OrderBookRecord] = []
        
        for _ in 0..<quantity {
            records.append(randomRecord())
        }
        
        return records
    }
    
    private static func randomRecord() -> OrderBookRecord {
        return OrderBookRecord(price: randomDouble, count: randomInt, amount: randomDouble)
    }
}
