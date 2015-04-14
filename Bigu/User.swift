//
//  User.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class User: BillingProtocol {
    // MARK: -Properties
    private var _name: String?
    var name: String {
        get {
            return _name != nil ? _name! : ""
        }
        set {
            if newValue == "" {
                _name = nil
            }
            else {
                _name = newValue
            }
        }
    }
    private var _surName: String?
    var surName: String? {
        get {
            return _surName != nil ? _surName! : ""
        }
        set {
            if newValue == "" {
                _surName = nil
            }
            else {
                _surName = newValue
            }
        }
    }
    var fullName: String {
        get {
            return name + " " + (surName != nil ? surName! : "")
        }
    }
    private var _nickName: String?
    var nickName: String? {
        get {
            return _nickName != nil ? _nickName! : ""
        }
        set {
            if newValue == "" {
                _nickName = nil
            }
            else {
                _nickName = newValue
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
    init(name: String, surName: String?, nickName: String?, handler: BillingHandlerDelegate?) {
        self.name = name
        self.surName = surName
        self.nickName = nickName
        self.handler = handler
        self.userImage = nil
    }
    init(name: String, surName: String?, nickName: String?, bill: Float?, userImage: UIImage?, handler: BillingHandlerDelegate?) {
        self.name = name
        self.surName = surName
        self.nickName = nickName
        self.handler = handler
        self.userImage = userImage
        self._bill = bill
    }
    func synchronize() {
        User.usersList.insertUser(self)
    }
    
    // MARK: -Protocols
    // MARK: BillingProtocol
    private var _bill: Float?
    var bill: Float {
        get {
            return _bill != nil ? _bill! : 0
        }
    }
    var handler: BillingHandlerDelegate?
    func creditValue(value: Float) {
        _bill = (_bill != nil ? _bill! : 0) + value
    }
    func debitValue(value: Float) {
        _bill = (_bill != nil ? _bill! : 0) + value
        if _bill == 0 {
            _bill = nil
        }
    }
    func resetBalance() {
        _bill = nil
    }
    
    // MARK: -Class Properties and Methods
    class var usersList: UserList {
        return UserList.sharedUserList
    }
    class func saveToPersistence() {
        let manager = UserPersistenceManager()
        manager.save()
    }
    class func removeUserAtRow (row: Int) {
        UserList.sharedUserList.removeUserAtIndex(row)
    }
}