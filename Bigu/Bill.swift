//
//  Bill.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

class Bill {
    
    // MARK: -Properties
    private var _bill: Float? = nil
    private(set) var bill: Float {
        get {
            return self._bill != nil ? self._bill! : 0
        }
        set {
            self._bill = newValue
        }
    }
    private(set) var handler: BillingHandlerDelegate?
    var user: User?
    
    init() {}
    
    init(fromBillValue value: Float) {
        self.bill = value
    }
    
    // MARK: -Methods
    func payBill () {
        RootUser.singleton.savings += self.bill
        self._bill = 0;
        self.handler?.updateBillingUI()
    }
    
    func payPartialBill (payingValue value: Float) {
        RootUser.singleton.savings += value
        self.bill -= value
        self.handler?.updateBillingUI()
    }
    
    func increaseBill (value: Float) {
        self.bill += value
        if let usr = self.user {
            let ride = Ride(userId: usr.id, value: value)
            RideListManager.rideListSingleton.insertNewRide(ride)
        }
        self.handler?.updateBillingUI()
    }
    
    func registerAsHandler (handler: BillingHandlerDelegate) {
        self.handler = handler
        self.handler?.updateBillingUI()
    }
    
    func clearRegisteredHandler() {
        self.handler = nil
    }
}