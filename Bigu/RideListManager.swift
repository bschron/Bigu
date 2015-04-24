//
//  RideListManager.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/19/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import BrightFutures

class RideListManager: DataPersistenceDelegate {
    
    // MARK: -Properties
    let singleton: Bool
    private var _list: OrderedList<Ride>!
    var list: OrderedList<Ride> {
        get {
            return self._list
        }
        set {
            self._list = newValue
        }
    }
    private(set) var id: Int = -1
    var count: Int {
        return self.list.count
    }
    
    // MARK: -Methods
    private init(singleton: Bool) {
        self.singleton = singleton
        if singleton {
            self.id = 0
            self.list = OrderedList<Ride>(isOrderedBefore: RideListManager.defaultOrder)
            self.load()
            PersistenceManager.singleton.registerAsManager(self)
        }
    }
    
    init() {
        self.singleton = false
        self.list = OrderedList<Ride>(isOrderedBefore: RideListManager.defaultOrder)
        PersistenceManager.singleton.registerAsManager(self)
    }
    
    init(loadFromId id: Int) {
        self.singleton = false
        self.id = id
        self.list = OrderedList<Ride>(isOrderedBefore: RideListManager.defaultOrder)
        self.load()
        self.registerId(id)
        PersistenceManager.singleton.registerAsManager(self)
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
    
    func registerToAvailableId() {
        var firstAvailableId: Int?
        
        var last: Int = 0
        for cur in RideListManager.idList.arrayCopy() {
            if cur - last > 1 {
                firstAvailableId = last + 1
                break
            }
            last = cur
        }
        
        if firstAvailableId == nil {
            firstAvailableId = last + 1
        }
        
        self.registerId(firstAvailableId!)
    }
    
    func unregisterSelfId() {
        if self.id != -1 {
            RideListManager.idList.removeObject({ $0 == self.id })
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.removeObjectForKey(RideListManager.rideListKey(self.id))
            
            self.id = -1
        }
    }
    
    func insertNewRide(ride: Ride) {
        self.list.insert(ride)
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
                
                RideListManager.rideListIdsPersistenceSave()
                
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
        RideListManager.rideListIdsPersistenceLoad()
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
    class var rideListSingleton: RideListManager {
        struct wrap {
            static let list = RideListManager(singleton: true)
        }
        
        return wrap.list
    }
    class var defaultOrder: (Ride, Ride) -> Bool {
        return { $0.timingSinceOcurrence > $1.timingSinceOcurrence }
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
    private struct shouldLoadIdListWrap {
        static var shouldLoadIdList: Bool = true
    }
    class private func rideListIdsPersistenceSave() -> Bool {
        
        let rideListIdsKey = "RideListIDsKey"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let array = RideListManager.idList.arrayCopy()
        defaults.setObject(array, forKey: rideListIdsKey)
        
        return defaults.synchronize()
    }
    class private func rideListIdsPersistenceLoad() {
        if !RideListManager.shouldLoadIdListWrap.shouldLoadIdList {
            return
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let array = defaults.objectForKey("RideListIDsKey") as? Array<Int>
        
        RideListManager.idList.clearList()
        if array != nil {
            RideListManager.idList.insert(array!)
            RideListManager.shouldLoadIdListWrap.shouldLoadIdList = false
        }
    }
    class var greaterId: Int {
        RideListManager.rideListIdsPersistenceLoad()
        let greater = RideListManager.idList.getLastObject()
        return greater != nil ? (greater! + 1) : 1
    }
}