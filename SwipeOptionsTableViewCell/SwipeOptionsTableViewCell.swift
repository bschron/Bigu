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
    private var shouldTrigger: Bool {
        return self.contentView.frame.origin.x >= self.lockedPostion + 100
    }
    private var firstButton: SwipeOptionsButtonItem? {
        return self.leftButtonItems.first
    }
    private var state: cellState = .Unlocked
    private var secondaryButtonsAreHidden: Bool = false
    
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
        self.originalPosition = self.contentView.frame.origin.x
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
        
        if self.leftButtonItems.count == 1 {
            self.backgroundColor = self.firstButton!.backgroundColor
        }
    }
    
    private func setLockedPositionValue() {
        var result: CGFloat = 0
        for cur in self.leftButtonItems {
            result += cur.frame.width
        }
        self.lockedPostion = result
    }
    
    private func hideSecondaryLeftButtons() {
        if self.secondaryButtonsAreHidden || self.leftButtonItems.count == 1 {
            return
        }
        
        for cur in self.leftButtonItems {
            if cur !== self.firstButton! {
                cur.hidden = true
            }
        }
        self.secondaryButtonsAreHidden = true
    }
    
    private func revealSecondaryLeftButtons() {
        if !self.secondaryButtonsAreHidden || self.leftButtonItems.count == 1 {
            return
        }
        
        for cur in self.leftButtonItems {
            if cur !== self.firstButton! {
                cur.hidden = false
            }
        }
        self.secondaryButtonsAreHidden = false
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
        if self.shouldTrigger {
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
            self.restoreCell(true)
            self.state = .Unlocked
        }
    }
    
    private func proceedPanning(sender: UIPanGestureRecognizer) {
        enum Direction {
            case toRight
            case toLeft
        }
        
        var currentDirection: Direction = .toRight
        
        let toucheTransition = sender.locationInView(self.contentView).x - self.startingTouchePosition.x
        
        if toucheTransition >= 0 {
            currentDirection = .toRight
        }
        else {
            currentDirection = .toLeft
        }
        
        let position = self.contentView.frame.origin.x + toucheTransition
        
        if position < 0 {
            return
        }
        
        
        self.contentView.frame.origin.x = position
        
        if self.shouldTrigger {
            self.state = .Triggered
        }
        else if currentDirection == .toLeft {
            self.state = .Unlocked
        }
        else if self.contentView.frame.origin.x >= self.lockedPostion {
            self.state = .Locked
        }
        else if currentDirection == .toRight {
            self.state = .Locked
        }
        else {
            self.state = .Unlocked
        }
        
        if self.state == .Locked || self.state == .Triggered {
            if self.contentView.frame.origin.x > self.lockedPostion {
                self.firstButton!.center.x = self.contentView.frame.origin.x / 2
                self.hideSecondaryLeftButtons()
            }
        }
    }
    
    private func triggerAction() {
        self.leftButtonItems.first?.triggerAction(self.panGesture)
        self.state = .Unlocked
    }
    
    private func restoreLeftFirstButton(animated: Bool) {
        func action() {
            self.setFirstButtonWidth(self.originalLeftFirstButtonWidth, animated: false)
            self.firstButton!.frame.origin.x = 0
        }
        
        var function: () -> () = action
        
        if animated {
            UIView.animateWithDuration(0.2, animations: {
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
            self.contentView.frame.origin.x = self.originalPosition
            self.restoreLeftFirstButton(false)
            self.revealSecondaryLeftButtons()
        }
        
        if animated {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                function()
                }, completion: nil)
        }
        else {
            function()
        }
    }
    
    private func lockCell(animated: Bool) {
        let function: () -> () = {
            self.restoreCell(false)
            self.contentView.frame = CGRectOffset(self.contentView.frame, self.lockedPostion, 0)
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
