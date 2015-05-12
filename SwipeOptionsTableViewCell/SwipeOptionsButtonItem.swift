//
//  SwipeOptionsButtonItem.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/10/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

public class SwipeOptionsButtonItem: UIButton {
    
    private var action: (sender: AnyObject!) -> () = {sender in}
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.allZeros)
        self.setTitle("Option", forState: UIControlState.allZeros)
        self.addTarget(self, action: "triggerAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func triggerAction(sender: AnyObject!) {
        self.action(sender: sender)
    }
    
    class func frame(forCell cell: UITableViewCell) -> CGRect {
        let ratio = CGFloat(1.5)
        return CGRectMake(0, 0, cell.frame.height * ratio, cell.frame.height)
    }
}
