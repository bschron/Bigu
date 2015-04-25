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
        self.registerSelfId()
        
        // if it's the singleton History
        if self.id == 0 {
            self.registerToPersistence()
        }
    }
    
    internal init(fromDictionary dic: [NSString: NSObject]) {
        
        let id = dic[History.idKey] as! Int
        let rideHistoryId = dic[History.rideIdKey] as! Int
        let optionalExtractsDateListKey = dic[History.extractsDateListKeyKey] as? String
        
        self.id = id
        self.rideHistory = RideListManager(loadFromId: rideHistoryId)
        self.extractHistory = OrderedList<Extract>(isOrderedBefore: History.extractListDefaultOrder)
        
        if let extractsKey = optionalExtractsDateListKey {
            let defaults = NSUserDefaults.standardUserDefaults()
            let extractsDateListOptionalArray = defaults.objectForKey(extractsKey) as? Array<NSDate>
            if let dates = extractsDateListOptionalArray {
                let extracts = loadExtractHistory(extractsForDateLists: dates)
                self.extractHistory.insert(extracts)
            }
        }
    }
    
    public func toDictionary() -> [NSString: NSObject] {
        var dic = [NSString: NSObject]()
        
        dic[History.idKey] = self.id
        dic[History.rideIdKey] = self.rideHistory.id
        dic[History.extractsDateListKeyKey] = History.extractHistoryKey(extractForHistoryWithId: self.id)
        
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
        let result = History.idList.findBy({ $0 == self.id })
        
        if result.count == 0 {
            History.idList.insert(self.id)
        }
    }
    
    public func registerToPersistence() {
        if !self.registeredToManager {
            HistoryPersistenceManager.singleton.register(registerHistory: self)
            self.registeredToManager = true
        }
    }
    
    public func registerRide(userId id: Int, value: Float) {
        let ride = Ride(userId: id, value: value)
        self.rideHistory.insertNewRide(ride)
        History.singleton.rideHistory.insertNewRide(ride)
    }
    
    // MARK: -Class Properties and Functions
    class public var singleton: History {
        struct wrap {
            static let history = History(fromId: 0)
        }
        
        return wrap.history
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
    class private var extractsDateListKeyKey: String {
        return "HistoryDateListKeyKey"
    }
    class private func extractKey(extractForDate date: NSDate) -> String {
        return "HistoryExtractKey \(date)"
    }
    class private func historyKey(historyForId id: Int) -> String {
        return "HistoryWithId: \(id)"
    }
    class private func extractHistoryKey(extractForHistoryWithId id: Int) -> String {
        return "HistoryExtractListWithId \(id)"
    }
    class private var extractListDefaultOrder: (Extract, Extract) -> Bool {
        return {$0.secondsSinceOcurrence > $1.secondsSinceOcurrence}
    }
    class private var idList: OrderedList<Int> {
        struct wrap {
            static var list = History.idListLoad()
        }
        return wrap.list
    }
    class internal func idListSave() -> Bool {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let array = History.idList.arrayCopy()
        defaults.setObject(array, forKey: History.historyIdListKey)
        
        return defaults.synchronize()
    }
    class internal func idListLoad() -> OrderedList<Int> {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let array = defaults.objectForKey(History.historyIdListKey) as? Array<Int>
        let list = OrderedList<Int>(isOrderedBefore: { $0 < $1 })
        
        if array != nil {
            list.insert(array!)
        }
        
        return list
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
}