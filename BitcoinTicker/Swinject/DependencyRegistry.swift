//
//  DependencyRegistry.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 20/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard


protocol DependencyRegistry {
    var container: Container { get }
    
    // OrderBookCell Maker
    typealias OrderBookCellMaker = (UITableView, IndexPath, OrderBookRecord?, OrderBookRecord?) -> OrderBookCell
    func makeOrderBookCell(for tableView: UITableView,
                           at indexPath: IndexPath,
                           with buyRecord: OrderBookRecord?,
                           and sellRecord: OrderBookRecord?) -> OrderBookCell
    
    // OrderBookHeader Maker
    typealias OrderBookSectionHeaderMaker = (UITableView, Int) -> OrderBookSectionHeader
    func makeOrderBookSectionHeader(for tableView: UITableView,
                                    at section: Int) -> OrderBookSectionHeader
    
}

class DependencyRegistryImpl : DependencyRegistry {
    
    var container: Container
    
    init(container: Container) {
        
        Container.loggingFunction = nil
        
        self.container = container
        
        self.registerDependencies()
        self.assemble()
    }
    
    // MARK: - Makers
    func makeOrderBookCell(for tableView: UITableView,
                           at indexPath: IndexPath,
                           with buyRecord: OrderBookRecord?,
                           and sellRecord: OrderBookRecord?) -> OrderBookCell {
        
        let viewModel = OrderBookCellViewModelImpl(with: buyRecord, and: sellRecord)
        
        let cell = OrderBookCell.dequeue(from: tableView, for: indexPath, with: viewModel)
        return cell
    }
    
    func makeOrderBookSectionHeader(for tableView: UITableView,
                                    at section: Int) -> OrderBookSectionHeader {
        
        return OrderBookSectionHeader.dequeue(from: tableView, at: section)
    }
}

// MARK: - Dependencies
private extension DependencyRegistryImpl {
    
    func registerDependencies() {
        
        // WebSockets
        self.container.register(OrderBookWebSocket.self) { _ in
            OrderBookWebSocketImpl()
        }.inObjectScope(.container)
        
        self.container.register(TickerWebSocket.self) { _ in
            TickerWebSocketImpl()
        }.inObjectScope(.container)
    }
    
}

// MARK: - Assembler
private extension DependencyRegistryImpl {
   
    func assemble() {
        
        let assembler = Assembler(container: self.container)
        assembler.apply(assembly: DashboardViewModelAssembly())
        
    }
}
