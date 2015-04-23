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
    private var bill: Bill
    var rideHistory: RideListManager?
    var billValue: Float {
        return self.bill.bill
    }
    
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
        self.rideHistory = RideListManager()
        self.rideHistory!.registerToAvailableId()
    }
    override init(fromDictionary dic: [NSString : NSObject]) {
        let optionalBill = dic[User.billKey] as? Float
        self.bill = optionalBill != nil ? Bill(fromBillValue: optionalBill!) : Bill()
        super.init(fromDictionary: dic)
        let rideHistoryId = dic[User.rideHistoryKey] as? Int
        if let history = rideHistoryId {
            self.rideHistory = RideListManager(loadFromId: history)
        }
        else {
            self.rideHistory = RideListManager()
            self.rideHistory!.registerToAvailableId()
        }
    }
    
    override func toDictionary() -> [NSString : NSObject] {
        var dic = super.toDictionary()
        dic[User.billKey] = self.bill.bill
        return dic
    }
    
    func increaseBill() {
        let value:Float = Bill.taxValue
        
        self.bill.increaseBill(value)
        
        let ride = Ride(userId: self.id, value: value)
    }
    
    func payBill() {
        self.bill.payBill()
    }
    
    func payPartialBill(payingValue value: Float) {
        self.bill.payPartialBill(payingValue: value)
    }
    
    func registerAsBillHandler(handler: BillingHandlerDelegate) {
        self.bill.registerAsHandler(handler)
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
    class private var rideHistoryKey: String {
        return "RideHistoryKey"
    }
}