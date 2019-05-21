//
//  ViewController.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 18/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import UIKit

import RxSwift
import SwiftWebSocket

class DashboardViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bitcoinLogo: UIImageView!
    @IBOutlet weak var tickerContainer: UIView!
    @IBOutlet weak var lblTicker: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var lblLast: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    
    @IBOutlet weak var tickerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var orderBookActivityIndicator: UIActivityIndicatorView!
    
    
    private var viewModel: DashboardViewModel!
    
    private var orderBookState: OrderBookState!
    private var tickerState: TickerState!
    
    private var dataSource: OrderBookDataSource!
    
    private let bag = DisposeBag()
    
    // MARK: - Swinject Initializer for the ViewController
    // Gets called before viewDidLoad()
    // Properties set here can be safely used in viewDidLoad()
    func configure(with viewModel: DashboardViewModel,
                   orderBookCellMaker: @escaping DependencyRegistry.OrderBookCellMaker,
                   orderBookSectionHeaderMaker: @escaping DependencyRegistry.OrderBookSectionHeaderMaker) {
        
        self.viewModel = viewModel
        self.dataSource = OrderBookDataSource(with: orderBookCellMaker, and: orderBookSectionHeaderMaker)
    }
}

// MARK: - ViewController Lifecycle
extension DashboardViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "BTC/USD Ticker"
        
        self.uiSetup()
        self.configureTableView()
        self.rxSetup()
    }
}


// MARK: - Setup
private extension DashboardViewController {
    
    func uiSetup() {
        self.tickerContainer.backgroundColor = .primary
        self.bitcoinLogo.tintColor = UIColor.white
        
        self.lblTicker.textColor = UIColor.white
        self.lblLast.textColor = UIColor.white
        self.lblVolume.textColor = UIColor.white
        self.lblLow.textColor = UIColor.white
        self.lblPercentage.textColor = UIColor.white
        self.lblHigh.textColor = UIColor.white
        
    }
    
    func configureTableView() {
        // Register TableViewCell and SectionHeader with the TableView
        OrderBookCell.register(with: self.tableView)
        OrderBookSectionHeader.register(with: self.tableView)
        
        // Configure TableView
        self.tableView.dataSource       = self.dataSource
        self.tableView.delegate         = self.dataSource
        self.tableView.separatorStyle   = .none
        self.tableView.backgroundColor  = .primaryLight
    }
    
    func rxSetup()  {
        // Subscribe to the OrderBookStream
        self.viewModel.orderBookStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
             
                self?.renderOrderBook(with: state)
                
            }).disposed(by: bag)
        
        // Subscribe to the TickerStream
        self.viewModel.tickerStream()
            .subscribe(onNext: { [weak self] state in
                
                self?.renderTicker(with: state)
                
            }).disposed(by: bag)
        
    }
}

// MARK: - Renderers
private extension DashboardViewController {
    
    /// OrderBook Rendered
    func renderOrderBook(with state: OrderBookState) {
        
        if state.isLoading {
            self.orderBookActivityIndicator.start()
        }
        else if state.hasError {
            self.orderBookActivityIndicator.stop()
            
            // TODO: Handle Error State
        }
        else {
            self.orderBookActivityIndicator.stop()
            if let buyRecords = state.buyOrderRecords,
                let sellRecords = state.sellOrderRecords {
                
                self.dataSource.update(buyRecords: buyRecords, sellRecords: sellRecords)
                self.tableView.reloadData()
            }
        }
        
    }
    
    /// Ticker Rendered
    func renderTicker(with state: TickerState) {
        
        if state.isLoading {
            self.tickerActivityIndicator.start()
        }
        else if state.hasError {
            self.tickerActivityIndicator.stop()
            
            //TODO: Handle Error State
        }
        else {
            self.tickerActivityIndicator.stop()
            
            if let tickerRecord = state.tickerRecord {
                //TODO: Localization
                self.lblLast.text       = "LAST: $\(tickerRecord.lastPrice.twoDecimalString())"
                self.lblVolume.text     = "VOL: \(tickerRecord.volume.twoDecimalString())"
                self.lblLow.text        = "LOW: \(tickerRecord.low.twoDecimalString())"
                self.lblHigh.text       = "HIGH: \(tickerRecord.high.twoDecimalString())"
                
                let absPercent = tickerRecord.dailyChangePercentage.absolute().twoDecimalString() + "%"
                if tickerRecord.dailyChangePercentage < 0 {
                    self.lblPercentage.text = "🔽 " + absPercent
                    self.lblPercentage.textColor = UIColor.orange
                } else {
                    self.lblPercentage.text = "🔼 " + absPercent
                    self.lblPercentage.textColor = UIColor.green
                }
            }
        }
    }
}
