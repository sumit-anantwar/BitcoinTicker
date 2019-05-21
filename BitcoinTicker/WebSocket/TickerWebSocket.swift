//
//  TickerWebSocket.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 20/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import Foundation

import RxSwift
import SwiftWebSocket

protocol TickerWebSocket {
    func stream() -> Observable<TickerRecord>
}

class TickerWebSocketImpl : TickerWebSocket {
    
    private let webSocket: WebSocket
    private let publisher = PublishSubject<TickerRecord>()
    
    // Payload for Ticker
    private lazy var payload: String? = {
        
        var pl = [String : Any]()
        pl["event"] = "subscribe"
        pl["channel"] = "ticker"
        pl["pair"] = "BTCUSD"
        
        return pl.toJSONString()
    }()
    
    init() {
        self.webSocket = WebSocket(BITFINEX_PUBLIC_SOCKET_URL)
        self.webSocket.delegate = self
    }
    
    func stream() -> Observable<TickerRecord> {
        return publisher.asObservable()
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
extension TickerWebSocketImpl : WebSocketDelegate {
    
    func webSocketOpen() {
        // WebSocket is open
        // Send the Ticker Payload to start getting updates
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
        
        // Omit the success message
        // and messages containing "hb"
        if text.contains("[") &&
            !text.contains("hb") {
            
            let substr = text.dropFirst().dropLast().split(separator: ",")
            if substr.count >= 10 {
                if let changePercent   = Double(substr[6]),
                    let lastPrice       = Double(substr[7]),
                    let volume          = Double(substr[8]),
                    let high            = Double(substr[9]),
                    let low             = Double(substr[10]) {
                
                    // Generate the record
                    let tickerRecord = TickerRecord(dailyChangePercentage: (changePercent * 100),
                                                    lastPrice: lastPrice,
                                                    volume: volume,
                                                    high: high,
                                                    low: low)
                    
                    print(substr)
                    
                    // Publish the record
                    publisher.onNext(tickerRecord)
                }
            }
        }
    }
}
