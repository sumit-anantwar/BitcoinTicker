//
//  OrderBookDataSource.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 20/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import UIKit


class OrderBookDataSource : NSObject {
    
    private let orderBookCellMaker:             DependencyRegistry.OrderBookCellMaker
    private let orderBookSectionHeaderMaker:    DependencyRegistry.OrderBookSectionHeaderMaker
    
    private var buyRecords:     [OrderBookRecord] = []
    private var sellRecords:    [OrderBookRecord] = []
    
    init(with orderBookCellMaker: @escaping DependencyRegistry.OrderBookCellMaker,
         and orderBookSectionHeaderMaker: @escaping DependencyRegistry.OrderBookSectionHeaderMaker) {
        
        self.orderBookCellMaker             = orderBookCellMaker
        self.orderBookSectionHeaderMaker    = orderBookSectionHeaderMaker
        
        super.init()
    }
    
    func update(buyRecords: [OrderBookRecord], sellRecords: [OrderBookRecord]) {
        self.buyRecords = buyRecords
        self.sellRecords = sellRecords
    }
}

extension OrderBookDataSource : UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(self.buyRecords.count, self.sellRecords.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let buyRecord: OrderBookRecord?     = self.buyRecords.item(at: index)
        let sellRecord: OrderBookRecord?    = self.sellRecords.item(at: index)
        
        
        return self.orderBookCellMaker(tableView, indexPath, buyRecord, sellRecord)
    }
}

extension OrderBookDataSource : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return self.orderBookSectionHeaderMaker(tableView, section)
    }
    
}
