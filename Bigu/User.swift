//
//  User.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

class User: BillingProtocol{
    // MARK: -Properties
    private var _name: String?
    var name: String {
        get {
            return _name != nil ? _name! : ""
        }
        set {
            if newValue == "" {
                _name = nil
            }
            else {
                _name = newValue
            }
        }
    }
    private var _surName: String?
    var surName: String? {
        get {
            return _surName
        }
        set {
            if newValue == "" {
                _surName = nil
            }
            else {
                _surName = newValue
            }
        }
    }
    var fullName: String {
        get {
            return name + " " + (surName != nil ? surName! : "")
        }
    }
    private var _nickName: String?
    var nickName: String? {
        get {
            return _nickName
        }
        set {
            if newValue == "" {
                _nickName = nil
            }
            else {
                _nickName = newValue
            }
        }
    }
    
    
    // MARK: -Methods
    init(name: String, surName: String?, nickName: String?, handler: BillingHandlerDelegate) {
        self.name = name
        self.surName = surName
        self.nickName = nickName
        self.handler = handler
    }
    
    // MARK: -Protocols
    // MARK: BillingProtocol
    private var _bill: Float?
    var bill: Float {
        get {
            return _bill != nil ? _bill! : 0
        }
    }
    var handler: BillingHandlerDelegate?
    func creditValue(value: Float) {
        _bill = (_bill != nil ? _bill! : 0) + value
    }
    func debitValue(value: Float) {
        _bill = (_bill != nil ? _bill! : 0) + value
        if _bill == 0 {
            _bill = nil
        }
    }
    func resetBalance() {
        _bill = nil
    }
}