//
//  HistoryPersistenceManager.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/25/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import Persistence
import BrightFutures
import Collection

internal class HistoryPersistenceManager: DataPersistenceDelegate {
    // MARK: -Properties
    internal let list: OrderedList<History>
    
    // MARK: -Methods
    internal init() {
        self.list = OrderedList<History>(isOrderedBefore: { $0.id < $1.id })
        PersistenceManager.singleton.registerAsManager(self)
    }
    
    internal func register(registerHistory history: History) {
        self.list.insert(history)
    }
    
    // MARK: -Protocols
    // MARK: DataPersistenceDelegate
    internal var object: AnyObject? {
        get {
            return list
        }
        set {}
    }
    internal func save(context: ExecutionContext?) -> Future<Bool> {
        let exec: ExecutionContext = context != nil ? context! : Queue.global.context
        let promise = Promise<Bool>()
        
        future(context: exec, { () -> Result<Bool> in
            let defaults = NSUserDefaults.standardUserDefaults()
            let arrayCopy = self.list.arrayCopy()
            for cur in arrayCopy {
                cur.saveExtractHistory(exec)
                let dictionary = cur.toDictionary()
                defaults.setObject(dictionary, forKey: HistoryPersistenceManager.historyKey(keyForId: cur.id))
            }
            let result = defaults.synchronize()
            
            if result {
                return .Success(Box(true))
            }
            else {
                return .Failure(NSError())
            }
        }).onSuccess(context: exec, callback: {result in
            promise.success(true)
        }).onFailure(context: exec, callback: {error in
            promise.failure(error)
        })
        
        return promise.future
    }
    
    // MARK: -Class Properties and Functions
    class internal var singleton: HistoryPersistenceManager {
        struct wrap {
            static let manager = HistoryPersistenceManager()
        }
        return wrap.manager
    }
    
    class private func historyKey(keyForId id: Int) -> String {
        return "HistoryPersistenceManagerWithId \(id)"
    }
    
    class internal func loadHistory(byId id: Int) -> History? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let key: String = HistoryPersistenceManager.historyKey(keyForId: id)
        let history: History?
        
        let optionalDictionary = defaults.objectForKey(key) as? [NSString: NSDictionary]
        
        if let dictionary = optionalDictionary {
            history = History(fromDictionary: dictionary)
        }
        else {
            history = nil
        }
        
        return history
    }
}