//
//  OrderBookCell.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 20/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import UIKit

class OrderBookCell: UITableViewCell {
    
    @IBOutlet weak var buyIndicator: UIView!
    @IBOutlet weak var sellIndicator: UIView!
    @IBOutlet weak var lblBuyPrice: UILabel!
    @IBOutlet weak var lblBuyAmount: UILabel!
    @IBOutlet weak var lblSellPrice: UILabel!
    @IBOutlet weak var lblSellAmount: UILabel!
    
    @IBOutlet weak var buyIndicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var sellIndicatorWidth: NSLayoutConstraint!
    
    
    func configure(with viewModel: OrderBookCellViewModel) {
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        let frame       = self.contentView.frame
        let halfWidth   = Double(frame.size.width * 0.5)
        
        self.lblBuyPrice.text       = viewModel.buyPriceStr
        self.lblBuyPrice.textColor  = UIColor.white
        
        self.lblBuyAmount.text      = viewModel.buyAmountStr
        self.lblBuyAmount.textColor = UIColor.white
        
        self.lblSellPrice.text      = viewModel.sellPriceStr
        self.lblSellPrice.textColor = UIColor.white
        
        self.lblSellAmount.text     = viewModel.sellAmountStr
        self.lblSellAmount.textColor = UIColor.white
        
        self.buyIndicator.backgroundColor = .bookCellBuy
        self.buyIndicatorWidth.constant =
            CGFloat(viewModel.getBuyIndicatorWidth(for: halfWidth))
        
        self.sellIndicator.backgroundColor = .bookCellSell
        self.sellIndicatorWidth.constant =
            CGFloat(viewModel.getSellIndicatorWidth(for: halfWidth))
    }
}

//MARK: - Helper Methods
extension OrderBookCell {
    public static var cellId: String {
        return String(describing: OrderBookCell.self)
    }
    
    public static var bundle: Bundle {
        return Bundle(for: OrderBookCell.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: OrderBookCell.cellId, bundle: OrderBookCell.bundle)
    }
    
    public static func register(with tableView: UITableView) {
        tableView.register(OrderBookCell.nib, forCellReuseIdentifier: OrderBookCell.cellId)
    }
    
    public static func loadFromNib(owner: Any?) -> OrderBookCell {
        return bundle.loadNibNamed(OrderBookCell.cellId, owner: owner, options: nil)?.first as! OrderBookCell
    }
    
    
    public static func dequeue(from tableView: UITableView, for indexPath: IndexPath, with orderBookCellViewModel: OrderBookCellViewModel) -> OrderBookCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderBookCell.cellId, for: indexPath) as! OrderBookCell
        cell.configure(with: orderBookCellViewModel)
        
        return cell
    }
}
