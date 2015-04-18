//
//  AbstractUser.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/15/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class AbstractUser {
    // MARK: -Properties
    private var _name: String?
    var name: String {
        get {
            return self._name != nil ? self._name! : ""
        }
        set {
            if newValue == "" {
                self._name = nil
            }
            else {
                self._name = newValue
            }
        }
    }
    private var _surName: String?
    var surName: String? {
        get {
            return self._surName != nil ? self._surName! : ""
        }
        set {
            if newValue == "" {
                self._surName = nil
            }
            else {
                self._surName = newValue
            }
        }
    }
    var fullName: String {
        get {
            return self.name + " " + (self.surName != nil ? self.surName! : "")
        }
    }
    private var _nickName: String?
    var nickName: String? {
        get {
            return self._nickName != nil ? self._nickName! : ""
        }
        set {
            if newValue == "" {
                self._nickName = nil
            }
            else {
                self._nickName = newValue
            }
        }
    }
    private var _userImage: UIImage? = nil
    var userImage: UIImage? {
        get {
            return self._userImage != nil ? self._userImage! : UIImage(named: "user")
        }
        set {
            self._userImage = newValue
        }
    }
    
    
    // MARK: -Methods
    init() {}
    init(name: String, surName: String?, nickName: String?) {
        self.name = name
        self.surName = surName
        self.nickName = nickName
        self.userImage = nil
    }
    init(name: String, surName: String?, nickName: String?, userImage: UIImage?) {
        self.name = name
        self.surName = surName
        self.nickName = nickName
        self.userImage = userImage
    }
    
    // MARK: -Protocols
}