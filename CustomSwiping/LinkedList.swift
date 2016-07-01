//
//  LinkedList.swift
//  CustomSwiping
//
//  Created by Эллина Кузнецова on 30.06.16.
//  Copyright © 2016 Эллина Кузнецова. All rights reserved.
//

import Foundation

public class LinkedListNode<T>: AnyObject {
    var value: T
    var next: LinkedListNode?
    weak var previous: LinkedListNode?
    
    public init(value: T) {
        self.value = value
    }
}

public class LinkedList<T> {
    public typealias Node = LinkedListNode<T>
    
    private var head: Node?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node? {
        return head
    }
    
    public var last: Node? {
        return self.nodeAtIndex(self.count - 1)
    }
    
    public var count: Int = 0
    
    public func nodeAtIndex(index: Int) -> Node? {
        if index >= 0 {
            var node = head
            var i = index
            while node != nil {
                if i == 0 { return node }
                i -= 1
                node = node!.next
            }
        }
        return nil
    }
    
    public subscript(index: Int) -> T {
        let node = nodeAtIndex(index)
        assert(node != nil)
        return node!.value
    }
    
    public func append(value: T) {
        let newNode = Node(value: value)
        
        if let lastNode = last {
            newNode.previous = lastNode
            newNode.next = head
            lastNode.next = newNode
            head?.previous = newNode
        } else {
            head = newNode
        }
        self.count += 1
    }
    
    public func append(values: [T]) {
        for value in values {
            self.append(value)
        }
    }
    
    public func insert(value: T, at index: Int) {
        guard index < self.count else {return}
        var nodeToInsertBefore = self.head
        for _ in 0..<index {
            nodeToInsertBefore = nodeToInsertBefore?.next
        }
        let node = Node(value: value)
        let previousNode = nodeToInsertBefore?.previous
        let nextNode = nodeToInsertBefore
        previousNode?.next = node
        node.previous = previousNode
        nextNode?.previous = node
        node.next = nextNode
        if index == 0 {
            self.head = node
        }
        self.count += 1
    }
    
    private func nodesBeforeAndAfter(index: Int) -> (Node?, Node?) {
        assert(index >= 0)
        
        var i = index
        var next = head
        var prev: Node?
        
        while next != nil && i > 0 {
            i -= 1
            prev = next
            next = next!.next
        }
        assert(i == 0)  // if > 0, then specified index was too large
        
        return (prev, next)
    }
    
    public func removeAll() {
        head = nil
    }
    
    public func removeNode(node: Node) -> T {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev
        
        node.previous = nil
        node.next = nil
        self.count -= 1
        return node.value
    }
    
    public func removeLast() -> T {
        assert(!isEmpty)
        return removeNode(last!)
    }
    
    public func removeAtIndex(index: Int) -> T {
        let node = nodeAtIndex(index)
        assert(node != nil)
        if index == 0 {
            self.head = node?.next
        }
        return removeNode(node!)
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        var s = "["
        var node = head
        
        for i in 0..<self.count {
            s += "\(node!.value)"
            node = node!.next
            if i < self.count - 1 { s += ", " }
        }
        return s + "]"
        
    }
}