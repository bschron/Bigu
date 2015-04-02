//
//  Bill.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

class Bill {
    // MARK: - Properties
    private var _balance: Double = 0
    var balance: Double {
        get {
            return _balance
        }
    }
    
    // MARK: - Methods
    func debitValue(value: Double) -> Double {
        self._balance += value
        return self.balance
    }
    
    func creditValue(value: Double) {
        self._balance -= value
    }
    
    func cleanBalance() -> Double {
        self._balance = 0
        return self.balance
    }
}