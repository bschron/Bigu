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
    /* the current pocket balance */
    var balance: Double = 0
    
    // MARK: - Methods
    func debitValue(value: Double) -> Double {
        self.balance += value
        return self.balance
    }
    
    func creditValue(value: Double) {
        self.balance -= value
    }
    
    func cleanBalance() -> Double {
        self.balance = 0
        return self.balance
    }
}