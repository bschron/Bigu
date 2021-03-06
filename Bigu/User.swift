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
import ExpectedError

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
    private init(fromAbstractUser absUsr: AbstractUser) {
        
        self.bill = Bill()
        self.history = History()
        super.init(withid: absUsr.id)
        self.history.registerToPersistence()
        
        self.userImage = absUsr.userImage
        self.name = absUsr.name
        self.surName = absUsr.surName
        self.homeLocation = absUsr.homeLocation
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
    override class public func loadUserFromAddressBook(viewController vc: UIViewController, person: ABRecord!, address add: Future<NSDictionary>) -> Future<AbstractUser> {
        
        let promise = Promise<AbstractUser>()
        
        let futureAbsUsr = super.loadUserFromAddressBook(viewController: vc, person: person, address: add)
        
        futureAbsUsr.onSuccess { absUsr in
            promise.success(User(fromAbstractUser: absUsr))
        }.onFailure{ error in
            let err = error as! ExpectedError
            if err.id == NewUserError.codeSet.choseNoAddress.rawValue ||
                err.id == NewUserError.codeSet.couldNotFindLocation.rawValue ||
                 err.id == NewUserError.codeSet.hasNoAddress.rawValue {
                let usr = error.valueForKey("newUser") as! AbstractUser
                err.setValue(User(fromAbstractUser: usr), forKey: "newUser")
            }
            
            promise.failure(error)
        }
        
        return promise.future
    }
}