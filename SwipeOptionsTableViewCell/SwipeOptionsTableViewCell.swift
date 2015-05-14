//
//  SwipeOptionsTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/10/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

private enum cellState {
    case Locked
    case Unlocked
    case Triggered
}

public class SwipeOptionsTableViewCell: UITableViewCell {
    // MARK: -Properties
    private var leftButtonItems: [SwipeOptionsButtonItem] = []
    private var panGesture: UIPanGestureRecognizer!
    private var originalPosition: CGFloat!
    private var startingTouchePosition: CGPoint = CGPoint(x: 0, y: 0)
    private var originalLeftFirstButtonWidth: CGFloat!
    private var lockedPostion: CGFloat {
        var result = CGFloat(0)
        for cur in self.leftButtonItems {
            result += cur.frame.width
        }
        return result
    }
    private var triggerMinimumPosition: CGFloat {
        return self.frame.width - 10
    }
    private var firstButton: SwipeOptionsButtonItem? {
        return self.leftButtonItems.first
    }
    private var state: cellState = .Unlocked
    // MARK: -Methods
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.panGesture = UIPanGestureRecognizer(target: self, action: "panAction:")
        self.originalPosition = self.center.x
        self.panGesture.minimumNumberOfTouches = 1
        self.panGesture.maximumNumberOfTouches = 1
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SwipeOptionsTableViewCell {
    // MARK: -PanActions
    private func panAction(sender: UIPanGestureRecognizer) {
        
        if self.leftButtonItems.count <= 0 {
            return
        }
        
        switch sender.state {
        case .Ended:
            self.finishPanning(sender)
        case .Began:
            self.startingTouchePosition = sender.locationInView(self)
            self.originalLeftFirstButtonWidth = self.leftButtonItems.first?.frame.width
        default:
            self.proceedPanning(sender)
        }
    }
    
    private func finishPanning(sender: UIPanGestureRecognizer) {
        self.startingTouchePosition = CGPoint(x: 0, y: 0)
        switch self.state {
        case .Unlocked:
            self.restoreCell(true)
        case .Locked:
            self.lockCell(true)
        case .Triggered:
            self.triggerAction()
            self.state = .Unlocked
        }
    }
    
    private func proceedPanning(sender: UIPanGestureRecognizer) {
        let toucheTransition = sender.locationInView(self).x - self.startingTouchePosition.x
        let position = self.originalPosition + toucheTransition
        
        self.center.x = position
        
        if sender.locationInView(self).x >= self.triggerMinimumPosition {
            self.state = .Triggered
        }
        else if(sender.locationInView(self).x >= self.lockedPostion) {
            self.state = .Locked
            self.bringSubviewToFront(self.leftButtonItems.first!)
        }
        else {
            self.state = .Unlocked
            self.bringSubviewToFront(self.contentView)
        }
        
        switch self.state {
        case .Locked:
            if position > self.lockedPostion {
                self.setFirstButtonWidth(position)
            }
            else {
                self.restoreLeftFirstButton(true)
            }
            
        default:
            let nothing = 0
        }
    }
    
    private func triggerAction() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.center.x = self.frame.width
            self.setFirstButtonWidth(self.frame.width)
            }, completion: { result in
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.center.x = self.originalPosition
                    self.restoreLeftFirstButton(false)
                    }, completion: { result in
                        self.leftButtonItems.first?.triggerAction(self.panGesture)
                        self.state = .Unlocked
                })
        })
    }
    
    private func restoreLeftFirstButton(animated: Bool) {
        func action() {
            self.setFirstButtonWidth(self.originalLeftFirstButtonWidth)
        }
        
        var function: () -> () = action
        
        if animated {
            UIView.animateWithDuration(0.5, animations: {
                function()
            })
        }
        else {
            function()
        }
    }
    
    private func setFirstButtonWidth(width: CGFloat) {
        func action() {
            self.firstButton!.frame = CGRect(x: self.firstButton!.center.x, y: self.firstButton!.center.y, width: width, height: self.firstButton!.frame.height)
        }
        
        let function: () -> () = action
        
        if self.firstButton!.frame.width != width {
            if self.firstButton!.frame.width > self.originalLeftFirstButtonWidth {
                function()
            }
            else {
                UIView.animateWithDuration(0.2, animations: {
                    function()
                })
            }
        }
    }
    
    private func restoreCell(animated: Bool) {
        let function: () -> () = {
            self.center.x = self.originalPosition
            self.restoreLeftFirstButton(false)
        }
        
        if animated {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowUserInteraction, animations: {
                function()
                }, completion: nil)
        }
        else {
            function()
        }
    }
    
    private func lockCell(animated: Bool) {
        let function: () -> () = {
            self.center.x = self.lockedPostion
            self.restoreLeftFirstButton(false)
        }
        
        if animated {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowUserInteraction, animations: {
                function()
                }, completion: nil)
        }
        else {
            function()
        }
    }
}
