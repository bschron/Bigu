//
//  RootUser.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit
import AbstractUser

public class RootUser: AbstractUser {
    // MARK: -Properties
    private var _savings: Float? = nil
    public var savings: Float {
        get {
            return self._savings != nil ? _savings! : 0
        }
        set {
            if newValue >= 0 {
                self._savings = newValue == 0 ? nil : newValue
            }
        }
    }
    
    // MARK: -Methods
    
    override internal init() {
        super.init()
        if self.name == "" {
            self.name = "You"
        }
    }
    override internal init(fromDictionary dic: [NSString : NSObject]) {
        super.init(fromDictionary: dic)
        self.name = dic[RootUser.nameKey] != nil ? dic[RootUser.nameKey] as! String : ""
        self._savings = dic[RootUser.savingsValueKey] as? Float
    }
    
    override public func toDictionary() -> [NSString : NSObject] {
        var dic = super.toDictionary()
        dic[RootUser.savingsValueKey] = self.savings
        return dic
    }
    
    // MARK: -Class Methods and Properties
    class public var singleton: RootUser {
        get {
            struct sing {
                static let root = RootUserPersistenceManager().load() as! RootUser
            }
            return sing.root
        }
    }
    class private var savingsValueKey: String {
        return "RootUserSavingValueKey"
    }
    class private var taxValueKey: String {
        return "RootUserTaxValueKey"
    }
}