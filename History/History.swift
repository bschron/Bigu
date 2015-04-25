//
//  History.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/25/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import Extract
import Collection
import Ride
import BrightFutures
import RootUser

public class History {
    // MARK: -Properties
    public let id: Int
    public let rideHistory: RideListManager
    public let extractHistory: OrderedList<Extract>
    private var registeredToManager: Bool = false
    
    // MARK: -Methods
    public init() {
        self.id = History.firstAvailableId()
        self.rideHistory = RideListManager()
        self.extractHistory = OrderedList<Extract>(isOrderedBefore: History.extractListDefaultOrder)
        
        self.rideHistory.registerToAvailableId()
        self.registerSelfId()
        History.idList.insert(self.id)
    }
    
    public init(fromId id: Int) {
        let optionalTwinCopy = HistoryPersistenceManager.loadHistory(byId: id)
        
        var selfId: Int = id
        var selfRides: RideListManager!
        var selfExtracts = OrderedList<Extract>(isOrderedBefore: History.extractListDefaultOrder)
        if let twin = optionalTwinCopy {
            selfId = twin.id
            selfRides = twin.rideHistory
            selfExtracts.insert(twin.extractHistory)
        }
        else {
            selfRides = RideListManager()
            selfRides.registerToAvailableId()
        }
        
        self.id = selfId
        self.rideHistory = selfRides
        self.extractHistory = selfExtracts
    }
    
    internal init(fromDictionary dic: [NSString: NSObject]) {
        
        let rideHistoryId = dic[History.rideIdKey] as! Int
        let extractsDateListOptionalArray = dic[History.extractsDateListKey] as? Array<NSDate>
        
        self.id = dic[History.idKey] as! Int
        self.rideHistory = RideListManager(loadFromId: rideHistoryId)
        self.extractHistory = OrderedList<Extract>(isOrderedBefore: History.extractListDefaultOrder)
        
        if let dates = extractsDateListOptionalArray {
            let extracts = loadExtractHistory(extractsForDateLists: dates)
            self.extractHistory.insert(extracts)
        }
    }
    
    public func toDictionary() -> [NSString: NSObject] {
        var dic = [NSString: NSObject]()
        
        dic[History.idKey] = self.id
        dic[History.rideIdKey] = self.rideHistory.id
        dic[History.extractsDateListKey] = self.makeExtractDatesList()
        
        return dic
    }
    
    private func makeExtractDatesList() -> Array<NSDate> {
        var list = Array<NSDate>()
        
        let extractListArray = self.extractHistory.arrayCopy()
        
        for cur in extractListArray {
            list += [cur.date]
        }
        
        return list
    }
    
    internal func saveExtractHistory(context: ExecutionContext?) -> Future<Bool> {
        let exec = context != nil ? context! : Queue.global.context
        
        let promise = Promise<Bool>()
        
        future(context: exec, { () -> Result<Bool> in
            let list = self.extractHistory.arrayCopy()
            let defaults = NSUserDefaults.standardUserDefaults()
            
            for cur in list {
                let extractDictionary = cur.toDictionary()
                defaults.setObject(extractDictionary, forKey: History.extractKey(extractForDate: cur.date))
            }
            
            let result = defaults.synchronize()
            
            if result {
                return .Success(Box(true))
            }
            else {
                return .Failure(NSError())
            }
        }).onSuccess(context: exec, callback: {result in
            promise.success(result)
        }).onFailure(context: exec, callback: { error in
            promise.failure(error)
        })
        
        return promise.future
    }
    
    private func loadExtractHistory(extractsForDateLists dates: Array<NSDate>) -> Array<Extract> {
        var list = Array<Extract>()
        let defaults = NSUserDefaults.standardUserDefaults()
        
        for cur in dates {
            let curDictionary = defaults.objectForKey(History.extractKey(extractForDate: cur)) as? [NSString: NSObject]
            if let dic = curDictionary {
                let extract = Extract(fromDictionary: dic)
                list += [extract]
            }
        }
        
        return list
    }
    
    public func unregisterSelfId() {
        History.idList.removeObject({ (cur: Int) -> Bool in
            return cur == self.id
        })
    }
    
    private func registerSelfId() {
        History.idList.insert(self.id)
    }
    
    public func registerToPersistence() {
        if !self.registeredToManager {
            HistoryPersistenceManager.singleton.register(registerHistory: self)
            self.registeredToManager = true
        }
    }
    
    // MARK: -Class Properties and Functions
    private struct wrap {
        static var shoudLoadIdList: Bool = true
    }
    class private var historyIdListKey: String {
        return "HistoryIdListKey"
    }
    class private var idKey: String {
        return "HistoryIdKey"
    }
    class private var rideIdKey: String {
        return "HistoryRideIdKey"
    }
    class private var extractsDateListKey: String {
        return "HistoryExtractsDateListKey"
    }
    class private func extractKey(extractForDate date: NSDate) -> String {
        return "HistoryExtractKey \(date)"
    }
    class private func historyKey(historyForId id: Int) -> String {
        return "HistoryWithId: \(id)"
    }
    class private var extractListDefaultOrder: (Extract, Extract) -> Bool {
        return {$0.secondsSinceOcurrence > $1.secondsSinceOcurrence}
    }
    class private var idList: OrderedList<Int> {
        struct wrap {
            static var list = OrderedList<Int>(isOrderedBefore: { $0 > $1 })
        }
        return wrap.list
    }
    class internal func idListSave() -> Bool {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let array = History.idList.arrayCopy()
        defaults.setObject(array, forKey: History.historyIdListKey)
        
        return defaults.synchronize()
    }
    class internal func idListLoad() {
        if !History.wrap.shoudLoadIdList {
            return
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let array = defaults.objectForKey(History.historyIdListKey) as? Array<Int>
        
        //History.idList.clearList()
        if array != nil {
            History.idList.insert(array!)
        }
        History.wrap.shoudLoadIdList = false
    }
    class private func firstAvailableId() -> Int {
        var firstAvailableId: Int?
        History.idListLoad()
        
        var last: Int = 0
        let ids = History.idList.arrayCopy()
        for cur in ids {
            if cur - last > 1 {
                firstAvailableId = last + 1
                break
            }
            last = cur
        }
        
        if firstAvailableId == nil {
            firstAvailableId = last + 1
        }
        
        return firstAvailableId!
    }
    class public func registerRide(forUserWithId id: Int, andHistory history: History, withValue value: Float) {
        let ride = Ride(userId: id, value: value)
        history.rideHistory.insertNewRide(ride)
        RootUser.singleton.history.rideHistory.insertNewRide(ride)
    }
}