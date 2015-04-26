//
//  Bill.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import BrightFutures

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
    public func charge (chargingValue value: Float) {
        self.bill -= value
        self.handler?.updateBillingUI()
    }
    
    public func pay (payingValue value: Float) {
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
    private struct wrap {
        static var firstRun: Bool = true
        static var tax: Float? = Bill.loadTaxValue() {
            didSet {
                if !Bill.wrap.firstRun {
                    Bill.saveTaxValue()
                }
                Bill.wrap.firstRun = false
            }
        }
    }
    class public var taxValue: Float {
        get {
            return Bill.wrap.tax != nil ? Bill.wrap.tax! : 0
        }
        set {
            if newValue <= 0 {
                Bill.wrap.tax = nil
            }
            else {
                Bill.wrap.tax = newValue
            }
        }
    }
    class private func saveTaxValue() {
        Queue.global.async({
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(Bill.wrap.tax, forKey: "BillTaxValueKey")
            defaults.synchronize()
        })
    }
    class private func loadTaxValue() -> Float? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey("BillTaxValueKey") as? Float
    }
}