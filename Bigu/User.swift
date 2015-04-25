//
//  User.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit
import AbstractUser
import Billing
import RootUser
import History

public class User: AbstractUser {
    
    // MARK: - Properties
    private var bill: Bill
    public var billValue: Float {
        return self.bill.bill
    }
    
    // MARK: -Methods
    
    override public init(withid id: Int) {
        self.bill = Bill()
        super.init(withid: id)
    }
    public init(name: String, surName: String?, nickName: String?, handler: BillingHandlerDelegate?) {
        self.bill = Bill()
        super.init(name: name, surName: surName, nickName: nickName)
        if let hand = handler {
            self.bill.registerAsHandler(hand)
        }
        self.userImage = nil
    }
    override public init(fromDictionary dic: [NSString : NSObject]) {
        let optionalBill = dic[User.billKey] as? Float
        self.bill = optionalBill != nil ? Bill(fromBillValue: optionalBill!) : Bill()
        
        let optionalHistoryId = dic[User.historyKey] as? Int
        
        super.init(fromDictionary: dic)
    }
    
    override public func toDictionary() -> [NSString : NSObject] {
        var dic = super.toDictionary()
        dic[User.billKey] = self.bill.bill
        return dic
    }
    
    public func increaseBill() {
        let value:Float = RootUser.singleton.taxValue
        
        self.bill.increaseBill(value)
        
        History.registerRide(forUser: self, withValue: value)
    }
    
    public func payBill() {
        self.bill.payBill()
    }
    
    public func payPartialBill(payingValue value: Float) {
        self.bill.payPartialBill(payingValue: value)
    }
    
    public func registerAsBillHandler(handler: BillingHandlerDelegate) {
        self.bill.registerAsHandler(handler)
    }
    
    // MARK: -Class Properties and Methods
    class private var billKey: String {
        return "UserBillKey"
    }
}