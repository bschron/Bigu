//
//  PlusCounter.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/16/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

internal class PlusCounter: Counter {
    
    private var vertical: UIView!
    private var horizontal: UIView!
    internal var bulk: CGFloat! {
        didSet {
            self.vertical.frame.size.width = self.bulk
            self.horizontal.frame.size.height = self.bulk
        }
    }
    override internal var color: UIColor {
        didSet{
            self.vertical.backgroundColor = self.color
            self.horizontal.backgroundColor = self.color
            self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
    }
    
    required internal init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override internal func setProperties() {
        super.setProperties()
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        self.vertical = UIView()
        self.horizontal = UIView()
        self.addSubview(self.vertical)
        self.addSubview(self.horizontal)
        self.bulk = 1.5
        self.vertical.backgroundColor = self.color
        self.vertical.frame.size.height = self.frame.height
        self.vertical.center.x = self.center.x
        self.vertical.center.y = self.center.y
        self.horizontal.backgroundColor = self.color
        self.horizontal.frame.size.width = self.frame.width
        self.horizontal.center.x = self.center.x
        self.horizontal.center.y = self.center.y
    }
}