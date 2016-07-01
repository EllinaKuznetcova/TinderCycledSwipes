//
//  DraggableView.swift
//  CustomSwiping
//
//  Created by Эллина Кузнецова on 29.06.16.
//  Copyright © 2016 Эллина Кузнецова. All rights reserved.
//

import UIKit

protocol DraggableViewDelegate {
    func cardDraggedLeft(card: DraggableView)
    func cardDraggedRight(card: DraggableView)
    func cardWillDragLeft(card: DraggableView)
    func cardWillDragRight(card: DraggableView)
    func cardEndedDrag(card: DraggableView)
}

class DraggableView: UIView {
    
    static var ActionMargin: CGFloat = 120
    static var ScaleStrength: CGFloat = 4
    static var ScaleMax: CGFloat = 0.93
    static var RotationMax: CGFloat = 1
    static var RotationStrength:CGFloat = 320
    static var RotationAngle: CGFloat = CGFloat(M_PI/8)
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    var delegate: DraggableViewDelegate?
    var information: UILabel?
    var index: Int = 0
    
    var xFromCenter: CGFloat = 0
    var yFromCenter: CGFloat = 0
    
    var originalPoint: CGPoint = CGPointMake(0, 0)
    
    var originalBounds: CGRect?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialization()
    }
    
    private func initialization() {
        self.panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(DraggableView.beingDragged(_:)))
        self.addGestureRecognizer(self.panGestureRecognizer!)
        
        self.information = UILabel.init(frame: CGRectMake(0, 50, self.frame.size.width, 100))
        self.information?.text = "some text"
        self.information?.textAlignment = NSTextAlignment.Center
        self.addSubview(self.information!)
        
        self.backgroundColor = UIColor.redColor()
        
    }
    
    func prepareView(index: Int) {
        self.information?.text = "view number \(index)"
        self.index = index
    }
    
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) {
        self.xFromCenter = gestureRecognizer.translationInView(self).x
        self.yFromCenter = gestureRecognizer.translationInView(self).y
        
        switch gestureRecognizer.state {
        case .Began:
            self.originalPoint = self.center
            self.originalBounds = self.bounds
        case .Changed:
            let rotationStrength = min(self.xFromCenter/DraggableView.RotationStrength, DraggableView.RotationMax)
            let rotationAngle = DraggableView.RotationAngle * rotationStrength
            let scale = max(1 - fabs(rotationStrength) / DraggableView.ScaleStrength, DraggableView.ScaleMax)
            
            self.center = CGPointMake(self.originalPoint.x + self.xFromCenter, self.originalPoint.y + self.yFromCenter)
            
            let transform = CGAffineTransformMakeRotation(rotationAngle)
            
            let scaleTransform = CGAffineTransformScale(transform, scale, scale)
            
            self.transform = scaleTransform
            if self.xFromCenter > 0 {
                self.delegate?.cardWillDragRight(self)
            }
            else {
                self.delegate?.cardWillDragLeft(self)
            }
        case .Ended:
            self.delegate?.cardEndedDrag(self)
            self.afterSwipeAction()
        default:
            return
        }
    }
    
    private func afterSwipeAction() {
        if self.xFromCenter > DraggableView.ActionMargin {
            self.rightAction()
        }
        else if self.xFromCenter < -DraggableView.ActionMargin {
            self.leftAction()
        }
        else {
            UIView.animateWithDuration(0.3, animations: {[weak self] in
                guard let sself = self else {return}
                sself.center = sself.originalPoint
                sself.transform = CGAffineTransformMakeRotation(0)
                })
        }
    }
    
    private func leftAction() {
        let finishPoint = CGPointMake(-500, self.center.y)
        UIView.animateWithDuration(0.3, animations: {[weak self] in
            self?.center = finishPoint
        }) { [weak self] (success) in
            guard let sself = self else {return}
            sself.removeFromSuperview()
            sself.delegate?.cardDraggedLeft(sself)
            sself.restoreFrame()
        }
    }
    
    private func rightAction() {
        let finishPoint = CGPointMake(500, self.center.y)
        UIView.animateWithDuration(0.3, animations: {[weak self] in
            self?.center = finishPoint
        }) { [weak self] (success) in
            guard let sself = self else {return}
            sself.removeFromSuperview()
            sself.delegate?.cardDraggedRight(sself)
            sself.restoreFrame()
        }
    }
    
    private func restoreFrame() {
        guard let lOrigialBounds = self.originalBounds else {return}
        self.bounds = lOrigialBounds
        self.center = self.originalPoint
        self.transform = CGAffineTransformMakeRotation(0)
    }
}

