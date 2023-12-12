//
//  Queue.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/3/23.
//

import Foundation

/// FIFO Queue Protocol
protocol Queue {
    associatedtype Item
    var isEmpty: Bool { get }
    var count: Int { get }
    
    func add(_ data: Item) -> Bool
    func peek() -> Item
    func poll() -> Item
}
