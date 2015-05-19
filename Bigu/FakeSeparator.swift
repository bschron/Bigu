//
//  FakeSeparator.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/24/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import RGBColor

public class FakeSeparator: UIView {
    
    private var cell: UITableViewCell!
    
    // MARK: -Methods
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(forView view: UITableViewCell) {
        super.init(frame: CGRectZero)
        self.cell = view
        
        let ratio = CGFloat(1)
        self.backgroundColor = RGBColor(r: 230, g: 230, b: 230, alpha: 1)
        view.contentView.addSubview(self)
        
        self.layoutIfNeeded()
    }
    
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.frame = CGRectMake(cell.contentView.frame.width / 8, cell.contentView.frame.height - 1, cell.contentView.frame.width - cell.contentView.frame.width / 8, 1)
    }
}
