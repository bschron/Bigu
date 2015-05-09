//
//  User.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit
import Billing
import History
import AbstractUser
import RootUser
import AddressBook
import BrightFutures

public class User: AbstractUser {
    
    // MARK: - Properties
    private var bill: Bill
    public var billValue: Float {
        return self.bill.bill
    }
    public let history: History
    
    // MARK: -Methods
    
    override public init(withid id: Int) {
        self.bill = Bill()
        self.history = History()
        super.init(withid: id)
        self.history.registerToPersistence()
    }
    public init(name: String, surName: String?, nickName: String?, handler: BillingHandlerDelegate?) {
        self.bill = Bill()
        self.history = History()
        super.init(name: name, surName: surName, nickName: nickName)
        if let hand = handler {
            self.bill.registerAsHandler(hand)
        }
        self.userImage = nil
        self.history.registerToPersistence()
    }
    override public init(fromDictionary dic: [NSString : NSObject]) {
        let optionalBill = dic[User.billKey] as? Float
        self.bill = optionalBill != nil ? Bill(fromBillValue: optionalBill!) : Bill()
        
        let optionalHistoryId = dic[User.historyIdKey] as? Int
        if let id = optionalHistoryId {
            self.history = History(fromId: id)
        }
        else {
            self.history = History()
        }
        
        super.init(fromDictionary: dic)
        self.history.registerToPersistence()
    }
    
    override public func toDictionary() -> [NSString : NSObject] {
        var dic = super.toDictionary()
        dic[User.billKey] = self.bill.bill
        dic[User.historyIdKey] = self.history.id
        return dic
    }
    
    public func charge() {
        let value:Float = Bill.taxValue
        
        self.bill.charge(chargingValue: value)
        
        self.history.registerRide(userId: self.id, value: value)
    }
    
    public func pay(payingValue value: Float) {
        if value != 0 {
            self.bill.pay(payingValue: value)
            
            self.history.registerExtract(userId: self.id, value: value)
            RootUser.singleton.savings += value
        }
    }
    
    public func registerAsBillHandler(handler: BillingHandlerDelegate) {
        self.bill.registerAsHandler(handler)
    }
    
    // MARK: -Class Properties and Methods
    class private var billKey: String {
        return "UserBillKey"
    }
    class internal var historyIdKey: String {
        return "UserHistoryIdKey"
    }
    override class public func loadUserFromAddressBook(viewController vc: UIViewController, person: ABRecord!) -> Future<AbstractUser> {
        let promise = Promise<AbstractUser>()
        
        let futureAbsUsr = super.loadUserFromAddressBook(viewController: vc, person: person)
        
        futureAbsUsr.onSuccess { absUsr in
            let usr = User(withid: absUsr.id)
            usr.userImage = absUsr.userImage
            usr.name = absUsr.name
            usr.surName = absUsr.surName
            usr.homeLocation = absUsr.homeLocation
            promise.success(usr)
        }.onFailure{ error in
            promise.failure(error)
        }
        
        return promise.future
    }
}