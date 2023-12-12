//
//  PriorityQueue.swift
//  Run Free
//
//  Created by Jordan Gallivan on 9/27/23.
//

import Foundation

/// Minimum Heap data structure.
class PriorityQueue<T:Comparable>: Queue, Sequence {
    typealias Element = T
    private var heap = [T]()
    var count: Int { heap.count }
    var isEmpty: Bool { count == 0 }
    
    init() { }
    
    init(collection: [T]) {
        self.heap = collection
        for i in (0...(count/2 - 1)).reversed() {
            heapify(i)
        }
    }
    
    /// Add an element to the Heap.
    ///
    /// - Parameter data: Element to be added to the heap.
    /// - Returns true if item was successfully added.
    @discardableResult
    func add(_ data: T?) -> Bool {
        guard let data = data else {
            return false
        }
        
        heap.append(data)
        var child = heap.count - 1
        var parent = Int((child - 1) / 2)
        
        while (parent >= 0 && heap[parent] > heap[child]) {
            heap.swapAt(parent, child)
            child = parent
            parent = Int((child - 1) / 2)
        }
        
        return true
    }
    
    /// Returns the minimum element in the Heap if one exists.
    func peek() -> T? {
        if isEmpty {
            return nil
        }
        
        return heap[0]
    }
    
    /// Returns and Removes the minimum element in the Heap if one exists
    func poll() -> T? {
        if isEmpty {
            return nil
        }
        let returnValue = heap[0]
        heap.swapAt(0, count - 1)
        heap.removeLast()
        
        heapify(0)
        
        return returnValue
    }
    
    
    private func heapify(_ parent: Int) {
        var parent = parent
        var leftChild, rightChild, minChild: Int
        while true {
            leftChild = 2 * parent + 1
            // verify heap size not exceeded
            if leftChild >= count {
                break
            }
            
            rightChild = leftChild + 1
            
            // assume minChild is left, verify
            minChild = leftChild
            if rightChild < count && heap[rightChild] < heap[leftChild] {
                minChild = rightChild
            }
            
            // validate heap property parent < children
            if heap[parent] > heap[minChild] {
                heap.swapAt(parent, minChild)
                parent = minChild
            } else {
                break
            }
        }
    }
    
    /// Iterates over the Heap from minimum to maximum element.
    func makeIterator() -> PriorityQueueIterator<T> {
        return PriorityQueueIterator<T>(self.heap)
    }
}

/// Iterator to iterate over the Heap from minimum to maximum element.
struct PriorityQueueIterator<T:Comparable>: IteratorProtocol {
    let heap: PriorityQueue<T>
    
    init(_ heap: [T]) {
        self.heap = PriorityQueue<T>(collection: heap)
    }
    
    mutating func next() -> T? {
        guard !heap.isEmpty else {
            return nil
        }
        
        return heap.poll()
    }
}
