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
    private var _list: OrderedList<Ride>!
    var list: OrderedList<Ride> {
        get {
            return self._list
        }
        set {
            self._list = newValue
        }
    }
    private var id: Int = -1
    
    // MARK: -Methods
    init(singleton: Bool) {
        self.singleton = singleton
        if singleton {
            self.list = RideListManager.rideListSingleton
            self.id = 0
        }
        else {
            self.list = OrderedList<Ride>(isOrderedBefore: RideListManager.defaultOrder)
        }
    }
    private func toArrayDictionary() -> [[NSString: NSObject]] {
        var array = [[NSString: NSObject]]()
        for cur in self.list.arrayCopy() {
            let dictionary = cur.toDictionary()
            array += [dictionary]
        }
        
        return array
    }
    
    func registerId(id: Int) -> Bool {
        let result: Bool!
        
        if id < 0 {
            result = false
        }
        else if RideListManager.idList.findBy({ $0 == id }).count > 0 { /* in case this id is registered already */
            result = false
        }
        else {
            self.id = id
            result = true
            RideListManager.idList.insert(id)
        }
        
        return result
    }
    
    func unregisterSelfId() {
        if self.id != -1 {
            RideListManager.idList.removeObject({ $0 == self.id })
            self.id = -1
        }
    }
    
    // MARK: -Protocols
    // MARK: DataPersistenceDelegate
    var object: AnyObject? {
        get {
            return self.list
        }
        set {}
    }
    func save(context: ExecutionContext?) -> Future<Bool> {
        let execContext = context != nil ? context! : Queue.global.context
        let promise = Promise<Bool>()
        
        if self.id == -1 {
            promise.failure(NSError(domain: "Unregistered RideListManager", code: -1, userInfo: nil))
        }
        else {
            future(context: execContext, { () -> Result<[[NSString: NSObject]]> in
                let array = self.toArrayDictionary()
                return .Success(Box(array))
            }).onSuccess(context: execContext, callback: { array in
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(array, forKey: RideListManager.rideListKey(self.id))
                let result = defaults.synchronize()
                
                if result {
                    promise.success(true)
                }
                else {
                    promise.failure(NSError())
                }
            })
        }
        
        return promise.future
    }
    
    func load() -> AnyObject? {
        if self.id == -1 {
            return nil
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = defaults.objectForKey(RideListManager.rideListKey(self.id)) as? [[NSString: NSObject]]
        var loadedObject: RideListManager? = nil
        
        if let array = data {
            self.list.clearList()
            for cur in array {
                let loadedRide = Ride(dictionary: cur)
                self.list.insert(loadedRide)
            }
            loadedObject = self
        }
        else {
            loadedObject = nil
        }
        
        return loadedObject
    }
    
    // MARK: -Class Methods and Properties
    class var rideListSingleton: OrderedList<Ride> {
        struct wrap {
            static let list = OrderedList<Ride>(isOrderedBefore: RideListManager.defaultOrder)
        }
        
        return wrap.list
    }
    class var defaultOrder: (Ride, Ride) -> Bool {
        return { $0.timingSinceOcurrence < $1.timingSinceOcurrence }
    }
    private struct idListWrap {
        static var list = OrderedList<Int>(isOrderedBefore: { $0 < $1 })
    }
    class private var idList: OrderedList<Int> {
        return RideListManager.idListWrap.list
    }
    class private func rideListKey(id: Int) -> String {
        return "\(id)" + "RideList"
    }
}