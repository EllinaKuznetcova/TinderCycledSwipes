//
//  DraggableCardsManager.swift
//  CustomSwiping
//
//  Created by Эллина Кузнецова on 29.06.16.
//  Copyright © 2016 Эллина Кузнецова. All rights reserved.
//

import UIKit


class DraggableCardsManagerView: UIView {
    
    var cardsLoadedIndex: Int = 0
    var loadedCards: [DraggableView] = []
    var cardSize: Int = 0
    
    var cards: DraggableArray<DraggableView, Int>?
    var data = [0]
    
    var cardFrame: CGRect {
        let width: CGFloat = 150
        let height: CGFloat = 150
        
        return CGRectMake((self.frame.width - width)/2, (self.frame.height - height)/2, width, height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func prepareView(index: Int) {
        self.loadCards(index)
    }
    
    private func loadCards(index: Int) {
        guard index < self.data.count else {return}
        self.cards = DraggableArray(data: self.data, cardIndexToPresent: index, delegate: self)
        guard let presentedCard = self.cards?.presentedCard else {return}
        self.addSubview(presentedCard)
    }
}

extension DraggableCardsManagerView: DraggableArrayDelegate {
    func initView(index: Int) -> Any {
        let view = DraggableView(frame: self.cardFrame)
        view.prepareView(index)
        view.delegate = self
        return view
    }
}

extension DraggableCardsManagerView: DraggableViewDelegate {
    func cardDraggedLeft(card: DraggableView) {
        self.cards?.toLeft()
    }
    
    func cardDraggedRight(card: DraggableView) {
        self.cards?.toRight()
    }
    
    func cardWillDragLeft(card: DraggableView) {
        guard self.cards?.previousCard != card else {return}
        self.cards?.previousCard.removeFromSuperview()
        guard let nextCard = self.cards?.nextCard else {return}
        self.insertSubview(nextCard, belowSubview: card)
    }
    
    func cardWillDragRight(card: DraggableView) {
        guard self.cards?.nextCard != card else {return}
        self.cards?.nextCard.removeFromSuperview()
        guard let previousCard = self.cards?.previousCard else {return}
        self.insertSubview(previousCard, belowSubview: card)
    }
    
    func cardEndedDrag(card: DraggableView) {
    }
}

