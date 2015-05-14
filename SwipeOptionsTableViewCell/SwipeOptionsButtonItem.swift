//
//  SwipeOptionsButtonItem.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/10/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

public class SwipeOptionsButtonItem: UIButton {
    
    // MARK: -Properties
    public var action: (sender: AnyObject) -> () = {sender in}
    public var actionMark: UIImage? = nil
    
    // MARK: -Methods
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        super.setTitleColor(UIColor.whiteColor(), forState: UIControlState.allZeros)
        self.setTitle("Button", forState: UIControlState.allZeros)
        self.addTarget(self, action: "triggerAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    internal func triggerAction(sender: AnyObject!) {
        self.action(sender: sender)
    }
    
    public func flashActionMark(#animated: Bool) -> (() -> ())? {
        let mark: UIImage!
        
        if self.actionMark == nil {
            mark = UIImage(named: "checkMark")
        }
        else {
            mark = self.actionMark
        }
        
        let imageView = UIImageView(image: mark)
        imageView.alpha = CGFloat(0)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(imageView)
        imageView.frame = CGRectMake(0, 0, self.frame.width / 3, self.frame.height / 3)
        imageView.center.x = self.center.x
        imageView.center.y = self.center.y
        imageView.tintColor = UIColor.lightGrayColor()
    
        let action: () -> () = {
            imageView.alpha = CGFloat(1)
            self.titleLabel?.alpha = CGFloat(0)
        }
        
        let completion: () -> () = {
            imageView.alpha = CGFloat(0)
            imageView.removeFromSuperview()
            self.titleLabel?.alpha = CGFloat(1)
        }
        
        if animated {
            UIView.animateWithDuration(0.5, animations: {
                action()
                }, completion: { result in
                    UIView.animateWithDuration(0.5, animations: {
                        completion()
                    })
            })
        }
        else {
            action()
        }
        
        return completion
    }
    
    class public func frame(forCell cell: UITableViewCell) -> CGRect {
        let ratio = CGFloat(1.2)
        return CGRectMake(0, 0, cell.frame.height * ratio, cell.frame.height)
    }
}
