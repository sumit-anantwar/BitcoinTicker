//
//  OrderBookCellViewModel.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 20/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import Foundation

import Swinject

protocol OrderBookCellViewModel {
    var buyPriceStr:        String { get }
    var buyAmountStr:       String { get }
    var sellPriceStr:       String { get }
    var sellAmountStr:      String { get }
    
    func getBuyIndicatorWidth(for maxWidth: Double) -> Double
    func getSellIndicatorWidth(for maxWidth: Double) -> Double
}

class OrderBookCellViewModelImpl: OrderBookCellViewModel {
    
    var buyPriceStr:   String
    var buyAmountStr:  String
    var sellPriceStr:  String
    var sellAmountStr: String
    
    let buyAmount: Double?
    let sellAmount: Double?
    
    init(with buyRecord: OrderBookRecord?, and sellRecord: OrderBookRecord?) {
        
        self.buyAmount     = buyRecord?.amount
        self.sellAmount    = sellRecord?.amount.absolute()
        
        self.buyPriceStr   = buyRecord?.price.twoDecimalString()   ?? ""
        self.buyAmountStr  = self.buyAmount?.twoDecimalString()  ?? ""
        
        self.sellPriceStr  = sellRecord?.price.twoDecimalString()  ?? ""
        self.sellAmountStr = self.sellAmount?.twoDecimalString() ?? ""
    }
    
    func getBuyIndicatorWidth(for maxWidth: Double) -> Double {
        guard let buyAmount = self.buyAmount else { return 0 }
        
        return (maxWidth / 25.0) * buyAmount // Percent Width
    }
    
    func getSellIndicatorWidth(for maxWidth: Double) -> Double {
        guard let sellAmount = self.sellAmount else { return 0 }
        
        return (maxWidth / 25.0) * sellAmount // Percent Width
    }
}
