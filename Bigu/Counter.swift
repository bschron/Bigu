//
//  Counter.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/16/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

internal class Counter: UIView {
    internal var color: UIColor = UIColor.blueColor() {
        didSet {
            self.backgroundColor = self.color
        }
    }
    
    required internal init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setProperties()
    }
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.setProperties()
    }
    
    internal func setProperties() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.backgroundColor = self.color
    }
}
