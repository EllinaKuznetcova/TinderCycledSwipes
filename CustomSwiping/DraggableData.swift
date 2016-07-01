//
//  DraggableArray.swift
//  CustomSwiping
//
//  Created by Эллина Кузнецова on 01.07.16.
//  Copyright © 2016 Эллина Кузнецова. All rights reserved.
//

import Foundation

protocol DraggableDataDelegate: class {
    func initView(index: Int) -> Any
}

struct DraggableData<ViewType, DataType> {
    var cards = CycledLinkedList<ViewType>()
    var data = CycledLinkedList<DataType>()
    
    weak var delegate: DraggableDataDelegate?
    var capacity = 3
    
    var presentedCardDataIndex = 0
    
    var presentedCard: ViewType {
        return self.cards[self.capacity]
    }
    
    var previousCard: ViewType {
        return self.cards[self.getPreviousIndex(before: self.capacity, with: self.cards.count)]
    }
    
    var nextCard: ViewType {
        return self.cards[self.getNextIndex(after: self.capacity, with: self.cards.count)]
    }
    
    init() {}
    
    init(data: [DataType], cardIndexToPresent: Int, delegate: DraggableDataDelegate) {
        guard data.count > 0 else {self.capacity = 0; return}
        if data.count < self.capacity * 2 + 1 {
            self.capacity = (data.count - 1)
        }
        self.delegate = delegate
        self.data.append(data)
        self.presentedCardDataIndex = cardIndexToPresent
        let startIndex = self.getStartIndex(from: cardIndexToPresent)
        let lastIndex = self.getLastIndex(from: cardIndexToPresent)
        for i in startIndex..<lastIndex+1 {
            guard let view = self.delegate?.initView(i) as? ViewType else {return}
            self.cards.append(view)
        }
    }
    
    private func getStartIndex(from index: Int) -> Int {
        var resultIndex = index
        for _ in 0..<self.capacity {
            resultIndex = self.getPreviousIndex(before: resultIndex, with: self.data.count)
        }
        return resultIndex
    }
    
    private func getLastIndex(from index: Int) -> Int {
        var resultIndex = index
        for _ in 0..<self.capacity {
            resultIndex = self.getNextIndex(after: resultIndex, with: self.data.count)
        }
        return resultIndex
    }
    
    private func getNextIndex(after index:Int, with size: Int) -> Int {
        switch index {
        case let x where x == size - 1:
            return 0
        default:
            return index + 1
        }
    }
    
    private func getPreviousIndex(before index:Int, with size: Int) -> Int {
        switch index {
        case let x where x == 0:
            return size - 1
        default:
            return index - 1
        }
    }
    
    mutating func toRight() {
        self.presentedCardDataIndex = self.getPreviousIndex(before: self.presentedCardDataIndex, with: self.data.count)
        self.cards.removeLast()
        let viewIndex = self.getStartIndex(from: self.presentedCardDataIndex)
        guard let view = self.delegate?.initView(viewIndex) as? ViewType else {return}
        self.cards.insert(view, at: 0)
    }
    
    mutating func toLeft() {
        self.presentedCardDataIndex = self.getNextIndex(after: self.presentedCardDataIndex, with: self.data.count)
        self.cards.removeAtIndex(0)
        let viewIndex = self.getLastIndex(from: self.presentedCardDataIndex)
        guard let view = self.delegate?.initView(viewIndex) as? ViewType else {return}
        self.cards.append(view)
    }
}
