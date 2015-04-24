//
//  FakeSeparator.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/24/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import RGBColor

class FakeSeparator: UIView {

    
    // MARK: -Methods
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(forView view: UIView) {
        let frame = view.frame
        super.init(frame: frame)
        
        view.addSubview(self)
        self.frame.size.width = frame.size.width * 2
        self.frame.size.height = CGFloat(1)
        self.center.x = frame.width + frame.width / 30
        self.center.y = frame.size.height
        self.backgroundColor = RGBColor(r: 230, g: 230, b: 230, alpha: 1)
    }
}
