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
            handler?.reloadUsersData()
        }
    }
    private var _surName: String?
    var surName: String {
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
            handler?.reloadUsersData()
        }
    }
    var fullName: String {
        get {
            return self.name + ((self.surName != "") ? (" " + self.surName) : (""))
        }
    }
    private var _nickName: String?
    var nickName: String {
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
            handler?.reloadUsersData()
        }
    }
    private var _userImage: UIImage? = nil
    var userImage: UIImage? {
        get {
            return self._userImage != nil ? self._userImage! : UIImage(named: "user")
        }
        set {
            self._userImage = newValue
            handler?.reloadUsersData()
        }
    }
    var handler: UserHandlingDelegate? = nil
    let id: Int
    
    // MARK: -Methods
    init(name: String, surName: String?, nickName: String?) {
        self.name = name
        self.surName = surName != nil ? surName! : ""
        self.nickName = nickName != nil ? nickName! : ""
        self.userImage = nil
        self.id = AbstractUser.greaterId++
    }
    init(name: String, surName: String?, nickName: String?, userImage: UIImage?) {
        self.name = name
        self.surName = surName != nil ? surName! : ""
        self.nickName = nickName != nil ? nickName! : ""
        self.userImage = userImage
        self.id = AbstractUser.greaterId++
    }
    init(id: Int, name: String, surName: String?, nickName: String?, userImage: UIImage?) {
        self.name = name
        self.surName = surName != nil ? surName! : ""
        self.nickName = nickName != nil ? nickName! : ""
        self.userImage = userImage
        self.id = id
    }
    
    // MARK: -Class Properties and Methods
    private struct greaterIdWrap {
        static var greaterId: Int = 0
    }
    class var greaterId: Int {
        get {
        return User.greaterIdWrap.greaterId
        }
        set {
            User.greaterIdWrap.greaterId = newValue
        }
    }
}