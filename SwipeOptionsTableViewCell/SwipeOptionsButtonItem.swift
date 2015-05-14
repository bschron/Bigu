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
    public var action: (sender: AnyObject!) -> () = {sender in}
    
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
    
    class public func frame(forCell cell: UITableViewCell) -> CGRect {
        let ratio = CGFloat(1.5)
        return CGRectMake(0, 0, cell.frame.height * ratio, cell.frame.height)
    }
}
