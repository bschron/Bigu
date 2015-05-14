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
    private var lockedPostion: CGFloat = 0
    private var triggerMinimumPosition: CGFloat {
        return self.lockedPostion + self.firstButton!.center.x
    }
    private var firstButton: SwipeOptionsButtonItem? {
        return self.leftButtonItems.first
    }
    private var state: cellState = .Unlocked
    
    // MARK: -Methods
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.panGesture = UIPanGestureRecognizer(target: self, action: "panAction:")
        self.panGesture.minimumNumberOfTouches = 1
        self.panGesture.maximumNumberOfTouches = 1
        self.contentView.addGestureRecognizer(self.panGesture)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.originalPosition = 0
        // Initialization code
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func insertLeftButton(button: SwipeOptionsButtonItem) {
        self.insertSubview(button, belowSubview: self.contentView)
        button.frame = CGRectMake(lockedPostion, 0, button.frame.width, button.frame.height)
        self.leftButtonItems.append(button)
        self.setLockedPositionValue()
    }
    
    private func setLockedPositionValue() {
        var result: CGFloat = 0
        for cur in self.leftButtonItems {
            result += cur.frame.width
        }
        self.lockedPostion = result
    }
}

extension SwipeOptionsTableViewCell {
    // MARK: -PanActions
    public func panAction(sender: UIPanGestureRecognizer) {
        
        if self.leftButtonItems.count <= 0 {
            return
        }
        
        switch sender.state {
        case .Ended:
            self.finishPanning(sender)
        case .Began:
            self.startingTouchePosition = sender.locationInView(self.contentView)
            self.originalLeftFirstButtonWidth = self.leftButtonItems.first?.frame.width
        default:
            self.proceedPanning(sender)
        }
    }
    
    private func finishPanning(sender: UIPanGestureRecognizer) {
        if self.contentView.center.x > self.triggerMinimumPosition {
            self.state = .Triggered
        }
        
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
        
        //self.bringSubviewToFront(self.contentView)
    }
    
    private func proceedPanning(sender: UIPanGestureRecognizer) {
        let toucheTransition = sender.locationInView(self.contentView).x - self.startingTouchePosition.x
        let position = self.contentView.center.x + toucheTransition
        let translation = self.originalPosition + toucheTransition
        
        self.contentView.center.x = position
        
        if position >= self.triggerMinimumPosition + self.originalPosition  && self.state != .Triggered {
            self.state = .Triggered
        }
        else if translation >= self.lockedPostion + self.originalPosition && self.state != .Locked {
            self.state = .Locked
            //self.bringSubviewToFront(self.leftButtonItems.first!)
        }
        else if self.state != .Unlocked {
            self.state = .Unlocked
            //self.bringSubviewToFront(self.contentView)
        }
        
        switch self.state {
        case .Locked:
            if position > self.lockedPostion {
                self.setFirstButtonWidth(self.contentView.center.x - self.firstButton!.frame.width, animated: false)
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
            self.contentView.center.x = self.frame.width
            self.setFirstButtonWidth(self.frame.width, animated: false)
            }, completion: { result in
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.contentView.center.x = self.originalPosition
                    self.restoreLeftFirstButton(false)
                    }, completion: { result in
                        self.leftButtonItems.first?.triggerAction(self.panGesture)
                        self.state = .Unlocked
                })
        })
    }
    
    private func restoreLeftFirstButton(animated: Bool) {
        func action() {
            self.setFirstButtonWidth(self.originalLeftFirstButtonWidth, animated: false)
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
    
    private func setFirstButtonWidth(width: CGFloat, animated: Bool) {
        
        let function: () -> () = {
            self.firstButton!.frame.size.width = width
        }
        
        if self.firstButton!.frame.width != width {
            if animated {
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
            //self.contentView.center.x = self.originalPosition
            self.contentView.frame = CGRectMake(self.originalPosition, 0, self.frame.width, self.frame.height)
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
            self.contentView.center.x = self.lockedPostion + self.originalPosition
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
