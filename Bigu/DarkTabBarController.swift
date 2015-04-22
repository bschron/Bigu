//
//  DarkTabBarController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/21/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class DarkTabBarController: UITabBarController {
    override func viewDidLoad() {
        //self.tabBar.barTintColor = UIColor.blackColor()
        self.tabBar.barStyle = UIBarStyle.Black
        self.tabBar.tintColor = RGBColor.blackColor()
        self.tabBar.barTintColor = RGBColor(r: 41, g: 123, b: 74, alpha: 1)
    }
}
