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
    var bill: Bill
    
    // MARK: -Methods
    func synchronize() {
        User.usersList.insertUser(self)
    }
    
    override init(withid id: Int) {
        self.bill = Bill()
        super.init(withid: id)
    }
    init(name: String, surName: String?, nickName: String?, handler: BillingHandlerDelegate?) {
        self.bill = Bill()
        super.init(name: name, surName: surName, nickName: nickName)
        if let hand = handler {
            self.bill.registerAsHandler(hand)
        }
        self.userImage = nil
        self.bill.user = self
    }
    init(name: String, surName: String?, nickName: String?, bill: Float?, userImage: UIImage?, handler: BillingHandlerDelegate?) {
        self.bill = bill != nil ? Bill(fromBillValue: bill!) : Bill()
        super.init(name: name, surName: surName, nickName: nickName, userImage: userImage)
        if let hand = handler {
            self.bill.registerAsHandler(hand)
        }
        self.bill.user = self
    }
    init(id: Int, name: String, surName: String?, nickName: String?, bill: Float?, userImage: UIImage?, handler: BillingHandlerDelegate?) {
        self.bill = bill != nil ? Bill(fromBillValue: bill!) : Bill()
        super.init(id: id, name: name, surName: surName, nickName: nickName, userImage: userImage)
        if let h = handler {
            self.bill.registerAsHandler(h)
        }
        self.bill.user = self
    }
    override init(fromDictionary dic: [NSString : NSObject]) {
        let optionalBill = dic[User.billKey] as? Float
        self.bill = optionalBill != nil ? Bill(fromBillValue: optionalBill!) : Bill()
        super.init(fromDictionary: dic)
        self.bill.user = self
    }
    
    override func toDictionary() -> [NSString : NSObject] {
        var dic = super.toDictionary()
        dic[User.billKey] = self.bill.bill
        return dic
    }
    
    // MARK: -Class Properties and Methods
    class var usersList: UserList {
        return UserList.sharedUserList
    }
    class func removeUserAtRow (row: Int) {
        UserList.sharedUserList.removeUserAtIndex(row)
    }
    class private var billKey: String {
        return "UserBillKey"
    }
}