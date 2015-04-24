//
//  DarkTabBarController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/21/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import RGBColor

class DarkTabBarController: UITabBarController {
    override func viewDidLoad() {
        //self.tabBar.barTintColor = UIColor.blackColor()
        self.tabBar.barStyle = UIBarStyle.Black
        self.tabBar.tintColor = RGBColor(r: 76, g: 153, b: 107, alpha: 1)
        self.tabBar.barTintColor = RGBColor.blackColor()
    }
}
