//
//  User.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class User: AbstractUser, BillingProtocol {
    // MARK: -Methods
    func synchronize() {
        User.usersList.insertUser(self)
    }
    init(name: String, surName: String?, nickName: String?, handler: BillingHandlerDelegate?) {
        super.init(name: name, surName: surName, nickName: nickName)
        self.handler = handler
        self.userImage = nil
    }
    init(name: String, surName: String?, nickName: String?, bill: Float?, userImage: UIImage?, handler: BillingHandlerDelegate?) {
        super.init(name: name, surName: surName, nickName: nickName, userImage: userImage)
        self.handler = handler
        self._bill = bill
    }
    
    // MARK: -Protocols
    // MARK: BillingProtocol
    private var _bill: Float?
    var bill: Float {
        get {
            return self._bill != nil ? self._bill! : 0
        }
    }
    var handler: BillingHandlerDelegate?
    func creditValue(value: Float) {
        self._bill = (self._bill != nil ? self._bill! : 0) + value
    }
    func debitValue(value: Float) {
        self._bill = (self._bill != nil ? self._bill! : 0) + value
        if self._bill == 0 {
            self._bill = nil
        }
    }
    func resetBalance() {
        self._bill = nil
    }
    
    // MARK: -Class Properties and Methods
    class var usersList: UserList {
        return UserList.sharedUserList
    }
    class func removeUserAtRow (row: Int) {
        UserList.sharedUserList.removeUserAtIndex(row)
    }
}