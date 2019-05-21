//
//  DashboardViewModelTests.swift
//  SwissBorgTechTestTests
//
//  Created by Sumit Anantwar on 21/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking

@testable import BitcoinTicker


class DashboardViewModelTests: XCTestCase {

    // Mocks
    private var mockOrderBookWebSocket: OrderBookWebSocket!
    private var mockTickerWebSocket: TickerWebSocket!
    
    // SUT
    private var DashboardViewModel_SUT: DashboardViewModel!
    
    override func setUp() {
        
        self.mockOrderBookWebSocket = OrderBookWebSocket_TD()
        self.mockTickerWebSocket = TickerWebSocket_TD()
        
        self.DashboardViewModel_SUT = DashboardViewModelImpl(with: mockOrderBookWebSocket,
                                                             tickerSocket: mockTickerWebSocket)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_OrderBookStream_StartsWithLoading_CompletesWithSuccess() {
        
        // GIVEN THAT
        let blockingStream = try? self.DashboardViewModel_SUT.orderBookStream()
            .toBlocking().toArray()
        
        XCTAssertNotNil(blockingStream)
        
        // WHEN
        let first: OrderBookState? = blockingStream!.item(at: 0)
        
        // THEN
        XCTAssertNotNil(first)
        XCTAssertEqual(first!.isLoading, true)
        
        // WHEN
        let second: OrderBookState? = blockingStream!.item(at: 1)
        
        // THEN
        XCTAssertNotNil(second)
        XCTAssertEqual(second!.isLoading, false)
        XCTAssertEqual(second!.buyOrderRecords!.count, 25)
        XCTAssertEqual(second!.sellOrderRecords!.count, 20)
    }
    
    func test_TickerStream_StartsWithLoading_CompletesWithSuccess() {
        
        // GIVEN THAT
        let blockingStream = try? self.DashboardViewModel_SUT.tickerStream()
            .toBlocking().toArray()
        
        XCTAssertNotNil(blockingStream)
        
        // WHEN
        let first: TickerState? = blockingStream!.item(at: 0)
        
        // THEN
        XCTAssertNotNil(first)
        XCTAssertEqual(first!.isLoading, true)
        XCTAssertNil(first!.tickerRecord)
        
        // WHEN
        let second: TickerState? = blockingStream!.item(at: 1)
        
        // THEN
        XCTAssertNotNil(second)
        XCTAssertEqual(second!.isLoading, false)
        XCTAssertNotNil(second!.tickerRecord)
    }

    

}


// MARK: - Test Classes
class OrderBookWebSocket_TD : OrderBookWebSocket {
    
    func stream() -> Observable<OrderBookRecordSet> {
        
        let buyRecords = OrderBookRecordFactory.generateOrderBookRecords(quantity: 25)
        let sellRecords = OrderBookRecordFactory.generateOrderBookRecords(quantity: 20)
        
        let set = OrderBookRecordSet(buyRecords: buyRecords,
                                     sellRecords: sellRecords)
        
        return Observable.just(set)
    }
}

class TickerWebSocket_TD : TickerWebSocket {
    
    func stream() -> Observable<TickerRecord> {
        
        let tickerRecords = TickerRecordFactory.generateRandomTickerRecords(quantity: 20)
        
        return Observable.from(tickerRecords)
    }
}

