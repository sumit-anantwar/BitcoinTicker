//
//  OrderBookWebSocket.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 19/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import Foundation

import SwiftWebSocket
import RxSwift

protocol OrderBookWebSocket {
    func stream() -> Observable<OrderBookRecordSet>
}

class OrderBookWebSocketImpl : OrderBookWebSocket {
    
    private let webSocket: WebSocket
    private let publisher = PublishSubject<OrderBookRecordSet>()
    
    private var buyRecords:     [OrderBookRecord] = []
    private var sellRecords:    [OrderBookRecord] = []
    
    // Payload for OrderBook
    private lazy var payload: String? = {
        
        var pl = [String : Any]()
        pl["event"] = "subscribe"
        pl["channel"] = "book"
        pl["pair"] = "btcusd"
        pl["prec"] = "P0"
        pl["freq"] = "F1"
        pl["len"] = "25"
        
        return pl.toJSONString()
    }()
    
    init() {
        self.webSocket = WebSocket(BITFINEX_PUBLIC_SOCKET_URL)
        self.webSocket.delegate = self
    }
    
    func stream() -> Observable<OrderBookRecordSet> {
        return publisher.asObservable()
            // Wait for 50 ms for the stream to become silent and then forward all the collected records
            .debounce(0.50, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { [weak self] set in
                // Empty the record lists, so that we don't get duplicate records
                self?.buyRecords = []
                self?.sellRecords = []
                
                // and forward the incoming set
                return set
            }
            .do(onSubscribe: { [weak self] in
                // Open the WebSocket when an Observer subscribes
                self?.webSocket.open()
            }, onDispose: { [weak self] in
                // Close the WebSocket when the subscription is disposed
                self?.webSocket.close()
            })
    }
}

// MARK: - WebSocketDelegate
extension OrderBookWebSocketImpl : WebSocketDelegate {
    
    func webSocketOpen() {
        // WebSocket is open
        // Send the OrderBook Payload to start getting updates
        if let message = self.payload {
            self.webSocket.send(message)
        }
    }
    
    func webSocketClose(_ code: Int, reason: String, wasClean: Bool) {
        
    }
    
    func webSocketError(_ error: NSError) {
        self.publisher.onError(error)
    }
    
    func webSocketMessageText(_ text: String) {
        
        // Omit the success message, snapshot
        // and events containing "hb"
        if text.contains("[") &&
            !text.contains(",[[") &&
            !text.contains("hb") {
            
            // Trim and leading and trailing []
            // and split the string at ","
            let substr = text.dropFirst().dropLast().split(separator: ",")
            
            // Successful events have 4 values
            if substr.count >= 4 {
                if let price = Double(substr[1]),
                    let count = Int(substr[2]),
                    let amount = Double(substr[3]) {
                
                    // Collect the records based on Type
                    let record = OrderBookRecord(price: price, count: count, amount: amount)
                    if record.getRecordType() == .buy {
                        self.buyRecords.append(record)
                    } else {
                        self.sellRecords.append(record)
                    }
                    
                    // Create a Set from the collected records
                    let set = OrderBookRecordSet(buyRecords: self.buyRecords, sellRecords: self.sellRecords)
                    
                    // Publish the Set
                    self.publisher.onNext(set)
                }
            }
        }
        
        //TODO : Also handle error messages
    }
}
