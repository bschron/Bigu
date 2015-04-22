//
//  DarkNavigationController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/21/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class DarkNavigationController: UINavigationController {
    override func viewDidLoad() {
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = RGBColor.blackColor()
        self.navigationBar.barTintColor = RGBColor(r: 41, g: 123, b: 74, alpha: 1)
    }
}
