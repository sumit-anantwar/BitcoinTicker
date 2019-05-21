//
//  DashboardStates.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 20/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import Foundation


/// StateObject used for Rendering Order Book
struct OrderBookState {
    let isLoading: Bool
    let hasError: Bool
    let errorMessage: String?
    let buyOrderRecords: [OrderBookRecord]?
    let sellOrderRecords: [OrderBookRecord]?
    
    static func initial() -> OrderBookState {
        
        return OrderBookState(isLoading: true,
                              hasError: false,
                              errorMessage: nil,
                              buyOrderRecords: nil,
                              sellOrderRecords: nil)
    }
    
    static func error(with err: Error) -> OrderBookState {
        
        return OrderBookState(isLoading: false,
                              hasError: true,
                              errorMessage: err.localizedDescription,
                              buyOrderRecords: nil,
                              sellOrderRecords: nil)
    }
    
    static func success(with buyOrderRecords: [OrderBookRecord],
                        and sellOrderRecords: [OrderBookRecord]) -> OrderBookState {
        
        return OrderBookState(isLoading: false,
                              hasError: false,
                              errorMessage: nil,
                              buyOrderRecords: buyOrderRecords,
                              sellOrderRecords: sellOrderRecords)
    }
}

/// StateObject used for Rendering Ticker View
struct TickerState {
    let isLoading: Bool
    let hasError: Bool
    let errorMessage: String?
    let tickerRecord: TickerRecord?
    
    static func initial() -> TickerState {
        
        return TickerState(isLoading: true,
                           hasError: false,
                           errorMessage: nil,
                           tickerRecord: nil)
    }
    
    static func error(with err: Error) -> TickerState {
        
        return TickerState(isLoading: false,
                           hasError: true,
                           errorMessage: err.localizedDescription,
                           tickerRecord: nil)
    }
    
    static func success(with tickerRecord: TickerRecord) -> TickerState {
        
        return TickerState(isLoading: false,
                           hasError: false,
                           errorMessage: nil,
                           tickerRecord: tickerRecord)
    }
}
