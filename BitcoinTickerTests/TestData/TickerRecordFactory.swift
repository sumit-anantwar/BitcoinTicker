//
//  TickerRecordFactory.swift
//  SwissBorgTechTestTests
//
//  Created by Sumit Anantwar on 21/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import Foundation

@testable import BitcoinTicker

class TickerRecordFactory {
    
    static func generateRandomTickerRecords(quantity: Int) -> [TickerRecord] {
        var records: [TickerRecord] = []
        
        for _ in 0..<quantity {
            records.append(randomRecord())
        }
        
        return records
    }
    
    private static func randomRecord() -> TickerRecord {
        
        return TickerRecord(dailyChangePercentage: randomDouble,
                            lastPrice: randomDouble,
                            volume: randomDouble,
                            high: randomDouble,
                            low: randomDouble)
    }
    
}
