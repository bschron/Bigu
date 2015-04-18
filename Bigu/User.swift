//
//  User.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class User: AbstractUser {
    
    // MARK: - Properties
    var bill: Bill = Bill()
    
    // MARK: -Methods
    func synchronize() {
        User.usersList.insertUser(self)
    }
    init(name: String, surName: String?, nickName: String?, handler: BillingHandlerDelegate?) {
        super.init(name: name, surName: surName, nickName: nickName)
        if let hand = handler {
            self.bill.registerAsHandler(hand)
        }
        self.userImage = nil
    }
    init(name: String, surName: String?, nickName: String?, bill: Float?, userImage: UIImage?, handler: BillingHandlerDelegate?) {
        super.init(name: name, surName: surName, nickName: nickName, userImage: userImage)
        if let hand = handler {
            self.bill.registerAsHandler(hand)
        }
        if let b = bill {
            self.bill.increaseBill(b)
        }
    }
    
    // MARK: -Class Properties and Methods
    class var usersList: UserList {
        return UserList.sharedUserList
    }
    class func removeUserAtRow (row: Int) {
        UserList.sharedUserList.removeUserAtIndex(row)
    }
}