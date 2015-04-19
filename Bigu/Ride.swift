//
//  Ride.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

class Ride {
    // MARK: -Properties
    let time: NSDate
    weak var user: User?
    let value: Float
    var timingSinceOcurrence: NSTimeInterval {
        return self.time.timeIntervalSinceNow
    }
    var list: Array<Ride> = Array<Ride>()
    
    // MARK: -Methods
    init(time: NSDate, user: User, value: Float) {
        self.time = time
        self.user = user
        self.value = value
        Ride.rideListSingleton.insert(self)
    }
    
    init(user: User) {
        self.user = user
        self.time = NSDate()
        self.value = TaxCell.taxValue
        Ride.rideListSingleton.insert(self)
    }
    
    // MARK: -Class Methods and Properties
    class var rideListSingleton: OrderedList<Ride> {
        struct wrap {
            static let list = OrderedList<Ride>(isOrderedBefore: { $0.timingSinceOcurrence < $1.timingSinceOcurrence })
        }
        
        return wrap.list
    }
}