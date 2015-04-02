//
//  BillingProtocol.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/2/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

protocol BillingProtocol {
    var bill: Float {get}
    func creditValue(value: Float)
    func debitValue(value: Float)
    func resetBalance()
    var handler: BillingHandlerDelegate? { get set }
}