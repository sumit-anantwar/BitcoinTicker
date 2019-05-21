//
//  OrderBookSectionHeader.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 21/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import UIKit

class OrderBookSectionHeader : UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleBuyOrders: UILabel!
    @IBOutlet weak var titleSellOrders: UILabel!
    @IBOutlet weak var lblBuyPrice: UILabel!
    @IBOutlet weak var lblBuyAmount: UILabel!
    @IBOutlet weak var lblSellPrice: UILabel!
    @IBOutlet weak var lblSellAmount: UILabel!
    
    
    override func awakeFromNib() {
        
        // Configure the Elements
        self.titleBuyOrders.backgroundColor = .primaryDark
        self.titleBuyOrders.textColor = .green
        self.titleBuyOrders.text = "Title_BuyOrders".localized
        
        self.titleSellOrders.backgroundColor = .primaryDark
        self.titleSellOrders.textColor = .orange
        self.titleSellOrders.text = "Title_SellOrders".localized
        
        self.lblBuyPrice.backgroundColor = .primary
        self.lblBuyPrice.textColor = .white
        self.lblBuyPrice.text = "Lbl_Price".localized
        
        self.lblBuyAmount.backgroundColor = .primary
        self.lblBuyAmount.textColor = .white
        self.lblBuyAmount.text = "Lbl_Amount".localized
        
        self.lblSellPrice.backgroundColor = .primary
        self.lblSellPrice.textColor = .white
        self.lblSellPrice.text = "Lbl_Price".localized
        
        self.lblSellAmount.backgroundColor = .primary
        self.lblSellAmount.textColor = .white
        self.lblSellAmount.text = "Lbl_Amount".localized
        
    }
    
}


extension OrderBookSectionHeader {
    
    public static var cellId: String {
        return String(describing: OrderBookSectionHeader.self)
    }
    
    public static var bundle: Bundle {
        return Bundle(for: OrderBookSectionHeader.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: OrderBookSectionHeader.cellId, bundle: OrderBookSectionHeader.bundle)
    }
    
    public static func register(with tableView: UITableView) {
        tableView.register(OrderBookSectionHeader.nib, forHeaderFooterViewReuseIdentifier: OrderBookSectionHeader.cellId)
    }
    
    public static func dequeue(from tableView: UITableView, at section: Int) -> OrderBookSectionHeader {
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderBookSectionHeader.cellId) as! OrderBookSectionHeader
    }
}
