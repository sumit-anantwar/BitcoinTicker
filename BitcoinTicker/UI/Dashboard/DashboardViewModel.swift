//
//  TickerViewModel.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 19/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import Foundation

import Swinject
import RxSwift

protocol DashboardViewModel {
    func orderBookStream()  -> Observable<OrderBookState>
    func tickerStream()     -> Observable<TickerState>
}

class DashboardViewModelImpl: DashboardViewModel {
    
    private let orderBookSocket:    OrderBookWebSocket
    private let tickerSocket:       TickerWebSocket
    
    init(with orderBookSocket: OrderBookWebSocket, tickerSocket: TickerWebSocket) {
        self.orderBookSocket = orderBookSocket
        self.tickerSocket = tickerSocket
    }
    
    /// OrderBook Stream
    func orderBookStream() -> Observable<OrderBookState> {
        return self.orderBookSocket.stream()
            .map { set in
                return OrderBookState.success(with: set.buyRecords, and: set.sellRecords)
            }
            .catchError { error in
                return Observable.just(OrderBookState.error(with: error))
            }
            .startWith(OrderBookState.initial())
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    /// Ticker Stream
    func tickerStream() -> Observable<TickerState> {
        return tickerSocket.stream()
            .map { ticker in
                return TickerState.success(with: ticker)
            }
            .catchError { error in
                return Observable.just(TickerState.error(with: error))
            }
            .startWith(TickerState.initial())
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
}


/// Assembly
class DashboardViewModelAssembly : Assembly {
    
    func assemble(container: Container) {
        
        container.register(DashboardViewModel.self) { r in
            let orderBookSocket = r.resolve(OrderBookWebSocket.self)!
            let tickerSocket    = r.resolve(TickerWebSocket.self)!
            
            return DashboardViewModelImpl(with: orderBookSocket,
                                   tickerSocket: tickerSocket)
        }
    }
}
