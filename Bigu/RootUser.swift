//
//  RootUser.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class RootUser: AbstractUser {
    // MARK: -Properties
    private var _savings: Float? = nil
    var savings: Float {
        get {
            return self._savings != nil ? _savings! : 0
        }
        set {
            if newValue >= 0 {
                self._savings = newValue == 0 ? nil : newValue
            }
        }
    }
    
    // MARK: -Class Methods and Properties
    class var singleton: RootUser {
        get {
            struct sing {
                static let root = RootUser()
            }
            return sing.root
        }
    }
}