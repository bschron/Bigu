//
//  Bill.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

public class Bill {
    
    // MARK: -Properties
    private var _bill: Float? = nil
    public private(set) var bill: Float {
        get {
            return self._bill != nil ? self._bill! : 0
        }
        set {
            self._bill = newValue
        }
    }
    private(set) var handler: BillingHandlerDelegate?
    
    public init() {}
    
    public init(fromBillValue value: Float) {
        self.bill = value
    }
    
    // MARK: -Methods
    public func payBill () {
        self._bill = 0;
        self.handler?.updateBillingUI()
    }
    
    public func payPartialBill (payingValue value: Float) {
        self.bill -= value
        self.handler?.updateBillingUI()
    }
    
    public func increaseBill (value: Float) {
        self.bill += value
        self.handler?.updateBillingUI()
    }
    
    public func registerAsHandler (handler: BillingHandlerDelegate) {
        self.handler = handler
        self.handler?.updateBillingUI()
    }
    
    public func clearRegisteredHandler() {
        self.handler = nil
    }
    
    // MARK: -Class Properties and Methods
}