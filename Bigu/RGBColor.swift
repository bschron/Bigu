//
//  RGBColor.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/21/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class RGBColor: UIColor {
    // MARK: -Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(r: Float, g: Float, b: Float, alpha: CGFloat) {
        func convert(n: Float) -> CGFloat {
            return CGFloat(n) / 255
        }
        
        super.init(red: convert(r), green: convert(g), blue: convert(b), alpha: alpha)
    }
}