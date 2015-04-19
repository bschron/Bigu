//
//  RideListManager.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/19/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

class RideListManager: DataPersistenceDelegate {
    
    // MARK: -Properties
    var singleton: Bool = false
    private var _object: AnyObject?
    
    // MARK: -Methods
    init(singleton: Bool) {
        self.singleton = singleton
        if singleton {
            self.object = RideListManager.rideListSingleton
        }
    }
    
    // MARK: -Protocols
    // MARK: DataPersistenceDelegate
    var object: AnyObject? {
        get {
            return self._object
        }
        set {
            self._object = newValue
        }
    }
    func save(context: ExecutionContext?) -> Future<Bool> {
        let execContext = context != nil ? context! : Queue.global.context
        let promise = Promise<Bool>()
        future(context: execContext, { () -> Result<Bool> in
            let list = self.object as! OrderedList<Ride>
            for var i = 0, current = list.getFirstObject(); let cur = current; i++, current = list.getElementAtIndex(i) {
                
            }
        })
    }
    
    func load() -> AnyObject? {
        <#code#>
    }
    
    // MARK: -Class Methods and Properties
    class var rideListSingleton: OrderedList<Ride> {
        struct wrap {
            static let list = OrderedList<Ride>(isOrderedBefore: { $0.timingSinceOcurrence < $1.timingSinceOcurrence })
        }
        
        return wrap.list
    }
    class private var userKey: String {
        return "RideListManagerUserKey"
    }
}