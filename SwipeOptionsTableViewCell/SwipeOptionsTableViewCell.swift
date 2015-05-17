//
//  SwipeOptionsTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/10/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import RGBColor

private enum cellState {
    case LeftLocked
    case RightLocked
    case Unlocked
    case LeftTriggered
}

enum Direction {
    case toRight
    case toLeft
    case NoDirection
}

public class SwipeOptionsTableViewCell: UITableViewCell {
    // MARK: -Properties
    private var leftButtonItems: [SwipeOptionsButtonItem] = []
    private var rightButtonItems: [SwipeOptionsButtonItem] = []
    private var leftHiddenButtonsOriginalFrame: [CGRect]!
    private var rightHiddenButtonsOriginalFrame: [CGRect]!
    private var panGesture: UIPanGestureRecognizer!
    private var originalPosition: CGFloat!
    private var startingTouchePosition: CGPoint = CGPoint(x: 0, y: 0)
    private var originalLeftFirstButtonWidth: CGFloat!
    private var originalRightFirstButtonWidth: CGFloat!
    private var leftLockedPosition: CGFloat = 0
    private var rightLockedPosition: CGFloat = 0
    private var shouldLeftTrigger: Bool {
        return self.contentView.frame.origin.x >= min(self.leftLockedPosition + 100, self.contentView.frame.width - 100)
    }
    private var leftFirstButton: SwipeOptionsButtonItem? {
        return self.leftButtonItems.first
    }
    private var rightFirstButton: SwipeOptionsButtonItem? {
        return self.rightButtonItems.first
    }
    private var state: cellState = .Unlocked
    private var secondaryButtonsAreHidden: Bool = false
    private var rightSecondaryButtonsAreHidden: Bool = false
    private var currentDirection: Direction = .NoDirection
    private var leftFirstButtonOriginalBackgroundColor: UIColor!
    private var rightFirstButtonOriginalBackgroundColor: UIColor!
    public var leftButtonFeedbackColor: UIColor = UIColor.lightGrayColor()
    public var rightButtonFeedbackColor: UIColor = UIColor.lightGrayColor()
    private var shouldRespondToPan: Bool = false
    
    // MARK: -Methods
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.panGesture = UIPanGestureRecognizer(target: self, action: "panAction:")
        self.panGesture.minimumNumberOfTouches = 1
        self.panGesture.maximumNumberOfTouches = 1
        self.contentView.addGestureRecognizer(self.panGesture)
        self.contentView.backgroundColor = UIColor.whiteColor()
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
        button.frame = CGRectMake(0, 0, button.frame.width, button.frame.height)
        self.leftButtonItems.append(button)
        self.setLockedPositionValue()
        
        if self.leftButtonItems.count == 1 {
            button.didTriggerAction = {
                self.didTriggerAction()
            }
            self.leftFirstButtonOriginalBackgroundColor = button.backgroundColor
        }
        
        self.layoutSubviews()
    }
    
    public func insertRightButton(button: SwipeOptionsButtonItem) {
        self.insertSubview(button, belowSubview: self.contentView)
        button.frame = CGRectMake(0, 0, button.frame.width, button.frame.height)
        self.rightButtonItems.append(button)
        self.setLockedPositionValue()
        
        if self.rightButtonItems.count == 1 {
            button.didTriggerAction = {
                self.didTriggerAction()
            }
            self.rightFirstButtonOriginalBackgroundColor = button.backgroundColor
        }
        
        self.layoutSubviews()
    }
    
    private func setLockedPositionValue() {
        var result: CGFloat = 0
        for cur in self.leftButtonItems {
            result += cur.frame.width
        }
        self.leftLockedPosition = result
        
        result = 0
        for cur in self.rightButtonItems {
            result += cur.frame.width
        }
        self.rightLockedPosition = -result
    }
    
    private func hideSecondaryButtons(animated: Bool, direction: Direction) {
        if self.secondaryButtonsAreHidden {
            return
        }
        
        let action: () -> () = {
            var buttons: [SwipeOptionsButtonItem]!
            var frames: [CGRect] = []
            
            if direction == .toRight {
                buttons = self.leftButtonItems
            }
            else if direction == .toLeft {
                buttons = self.rightButtonItems
            }
            
            for cur in buttons {
                if cur !== self.leftFirstButton && cur !== self.rightFirstButton {
                    frames += [CGRectMake(cur.frame.origin.x, cur.frame.origin.y, cur.frame.width, cur.frame.height)]
                    cur.frame.origin.x += direction == .toRight ? self.frame.width : -self.frame.width
                }
            }
            
            if direction == .toRight {
                self.leftHiddenButtonsOriginalFrame = frames
            }
            else if direction == .toLeft {
                self.rightHiddenButtonsOriginalFrame = frames
            }
            
            self.secondaryButtonsAreHidden = true
        }
        
        if animated {
            UIView.animateWithDuration(0.3, animations: {
                action()
            })
        }
        else {
            action()
        }
    }
    
    private func revealSecondaryButtons(animated: Bool) {
        if !self.secondaryButtonsAreHidden || self.leftButtonItems.count == 1 {
            return
        }
        
        let action: () -> () = {
            for var j = 0; j < 2; j++ {
                var i = 0
                let buttons: [SwipeOptionsButtonItem] = j == 0 ? self.leftButtonItems : self.rightButtonItems
                let frames: [CGRect]! = j == 0 ? self.leftHiddenButtonsOriginalFrame : self.rightHiddenButtonsOriginalFrame
                
                if frames != nil {
                    for cur in buttons {
                        if cur !== self.leftFirstButton && cur !== self.rightFirstButton {
                            cur.frame = frames[i]
                            i++
                        }
                    }
                }
            }
            
            self.leftHiddenButtonsOriginalFrame = nil
            self.rightHiddenButtonsOriginalFrame = nil
            self.secondaryButtonsAreHidden = false
        }
        
        if animated {
            UIView.animateWithDuration(0.3, animations: {
                action()
            })
        }
        else {
            action()
        }
    }
    
    private func restoreFirstButtons(animated: Bool) {
        func action() {
            self.leftFirstButton?.backgroundColor = self.leftFirstButtonOriginalBackgroundColor
            self.rightFirstButton?.backgroundColor = self.rightFirstButtonOriginalBackgroundColor
            self.layoutSubviews()
        }
        
        var function: () -> () = action
        
        if animated {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                function()
                }, completion: nil)
        }
        else {
            function()
        }
    }
    
    private func setFirstButtonWidth(width: CGFloat, animated: Bool) {
        
        let function: () -> () = {
            self.leftFirstButton!.frame.size.width = width
        }
        
        if self.leftFirstButton!.frame.width != width {
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
    
    public func restoreCell(animated: Bool) {
        let function: () -> () = {
            self.setBackgroundColor()
            self.contentView.frame.origin.x = self.originalPosition
            self.restoreFirstButtons(false)
            self.revealSecondaryButtons(false)
        }
        
        if animated {
            var duration: NSTimeInterval = 0.002 * Double(self.contentView.frame.origin.x)
            
            if duration >= 0.3 {
                var factor = 1.0
                
                if duration > 1 {
                    factor = -factor
                }
                else if duration == 1 {
                    factor = 1.3
                }
                
                duration *= (factor - duration)
            }
            
            UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut | .AllowAnimatedContent, animations: {
                function()
                }, completion: { result in
                    //self.bounce(forView: self.contentView, movingToDirection: self.currentDirection, completion: nil)
            })
        }
        else {
            function()
        }
    }
    
    private func bounce(forView view: UIView, movingToDirection dir: Direction, completion: ((Bool) -> ())?) {
        let originalPosition = view.frame.origin.x
        let dx = view.frame.width / 40
        let duration: NSTimeInterval = 0.008 * Double(dx)
        
        let _bounce: (CGFloat) -> () = { dx in
            switch dir {
            case .toRight:
                view.frame.origin.x -= dx
            case .toLeft:
                view.frame.origin.x += dx
            case .NoDirection:
                view.frame.origin.x = 0
            }
            
        }
        
        UIView.animateWithDuration(duration, animations: {
            _bounce(dx)
            }, completion: { result in
                UIView.animateWithDuration(duration, animations: {
                    view.frame.origin.x = originalPosition
                    }, completion: { result in
                        UIView.animateWithDuration(duration / 2, animations: {
                            _bounce(dx / 2)
                            }, completion: { result in
                                UIView.animateWithDuration(duration / 2, animations: {
                                    view.frame.origin.x = originalPosition
                                    }, completion: completion)
                        })
                })
        })
    }
    
    private func triggerFeedbackBackGroundColor(# feedback: Bool, animated: Bool) {
        let action: () -> () = {
            let color = feedback ? self.leftButtonFeedbackColor : self.leftFirstButtonOriginalBackgroundColor
            self.leftFirstButton!.backgroundColor = color
            self.backgroundColor = color
        }
        
        if animated {
            UIView.animateWithDuration(0.2, animations: {
                action()
            })
        }
        else {
            action()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        var i = 0
        self.leftLockedPosition = 0
        for cur in self.leftButtonItems {
            cur.frame.origin.x = self.leftLockedPosition
            self.leftLockedPosition += cur.frame.width
        }
        
        self.rightLockedPosition = 0
        for cur in self.rightButtonItems {
            self.rightLockedPosition -= cur.frame.width
            cur.frame.origin.x = self.contentView.frame.width + self.rightLockedPosition
        }
    }
}

extension SwipeOptionsTableViewCell {
    // MARK: -PanActions
    public func panAction(sender: UIPanGestureRecognizer) {
        
        if self.leftButtonItems.count <= 0 && self.rightButtonItems.count <= 0 {
            return
        }
        
        switch sender.state {
        case .Ended:
            self.finishPanning(sender)
        case .Began:
            self.startingTouchePosition = sender.locationInView(self.contentView)
            self.originalLeftFirstButtonWidth = self.leftButtonItems.first?.frame.width
            self.originalRightFirstButtonWidth = self.rightButtonItems.first?.frame.width
        default:
            self.proceedPanning(sender)
        }
    }
    
    private func finishPanning(sender: UIPanGestureRecognizer) {
        switch self.currentDirection {
        case .toLeft:
            switch self.state {
            case .LeftLocked:
                self.state = .Unlocked
            case .LeftTriggered:
                self.state = .LeftLocked
            case .Unlocked:
                self.state = .RightLocked
            case .RightLocked:
                let nop = 0
            }
            
        case .toRight:
            switch self.state {
            case .LeftLocked:
                let nop = 0
            case .LeftTriggered:
                let nop = 0
            case .Unlocked:
                self.state = .LeftLocked
            case .RightLocked:
                self.state = .Unlocked
            }
            
        case .NoDirection:
            let nop = 0
        }
        
        self.currentDirection = .NoDirection
        
        self.startingTouchePosition = CGPoint(x: 0, y: 0)
        switch self.state {
        case .Unlocked:
            self.restoreCell(self.shouldRespondToPan)
        case .LeftLocked:
            self.lockCell(true)
        case .LeftTriggered:
            self.leftButtonItems.first?.triggerAction(self.panGesture)
        case .RightLocked:
            self.lockCell(true)
        }
    }
    
    private func proceedPanning(sender: UIPanGestureRecognizer) {
        
        let toucheTransition = sender.locationInView(self.contentView).x - self.startingTouchePosition.x
        
        if toucheTransition >= 0 {
            currentDirection = .toRight
        }
        else {
            currentDirection = .toLeft
        }
        
        let position = self.contentView.frame.origin.x + toucheTransition
        
        if (position < 0 && self.rightButtonItems.count <= 0) || (position > 0 && self.leftButtonItems.count <= 0) {
            self.shouldRespondToPan = false
            return
        }
        
        self.shouldRespondToPan = true
        
        let previousState = self.state
        
        self.contentView.frame.origin.x = position
        
        if self.shouldLeftTrigger {
            self.state = .LeftTriggered
        }
        else if self.contentView.frame.origin.x >= self.leftLockedPosition || (self.state == .Unlocked && self.currentDirection == .toRight)  {
            self.state = .LeftLocked
        }
        else if self.contentView.frame.origin.x > 0 {
            self.state = .Unlocked
            self.currentDirection = .NoDirection
        }
        else if self.contentView.frame.origin.x >= self.rightLockedPosition && self.contentView.frame.origin.x < 0 {
            self.state = .RightLocked
        }
        
        self.setBackgroundColor()
        
        self.interactWithButtons(previousState: previousState)
    }
    
    private func setBackgroundColor() {
        struct wrap {
            static var lastDirection: Direction = .NoDirection
        }
        
        let dir: Direction!
        if self.contentView.frame.origin.x < 0 {
            dir = .toLeft
        }
        else {
            dir = .toRight
        }
        
        if wrap.lastDirection == dir {
            return
        }
        
        wrap.lastDirection = dir
        
        if dir == .toRight {
            self.backgroundColor = self.leftFirstButton?.backgroundColor
        }
        else if dir == .toLeft {
            self.backgroundColor = self.rightFirstButton?.backgroundColor
        }
    }
    
    private func interactWithButtons(# previousState: cellState) {
        if self.state == .LeftLocked || self.state == .LeftTriggered {
            if self.contentView.frame.origin.x > self.leftLockedPosition {
                self.leftFirstButton?.center.x = self.contentView.frame.origin.x / 2
                self.hideSecondaryButtons(true, direction: .toRight)
            }
            
            if previousState != self.state {
                self.triggerFeedbackBackGroundColor(feedback: self.state == .LeftTriggered, animated: true)
            }
        }
        else if self.state == .RightLocked {
            if self.contentView.frame.origin.x < self.rightLockedPosition {
                self.rightFirstButton?.center.x = (self.contentView.frame.origin.x + self.contentView.frame.width) + (-self.contentView.frame.origin.x / 2)
                // stoped here
            }
        }
    }
    
    private func lockCell(animated: Bool) {
        let function: () -> () = {
            self.restoreCell(false)
            self.contentView.frame = CGRectOffset(self.contentView.frame, self.state == .LeftLocked ? self.leftLockedPosition : self.rightLockedPosition, 0)
        }
        
        if animated {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowUserInteraction | .AllowAnimatedContent, animations: {
                function()
                }, completion: nil)
        }
        else {
            function()
        }
    }
    
    public func didTriggerAction() {
        self.restoreCell(true)
        self.state = .Unlocked
    }
}
