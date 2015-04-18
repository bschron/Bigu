//
//  PersistenceManager.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

class PersistenceManager {
    
    // MARK: -Properties
    
    private var managersList: Array<DataPersistenceDelegate> = []
    
    // MARK: -Methods
    
    func registerAsManager(manager: DataPersistenceDelegate) {
        self.managersList += [manager]
    }
    
    func saveAllManagers(context: ExecutionContext?) -> Future<Bool> {
        let promise = Promise<Bool>()
        let executionContext = context != nil ? context! : Queue.global.context
        
        let futureResult = future(context: executionContext, { () -> Result<Bool> in
            var result = true
            var lastError: NSError!
            for cur in self.managersList {
                cur.save(executionContext).onFailure(context: executionContext, callback: { error in
                    lastError = error
                    result = false
                })
            }
            
            if result {
                return .Success(Box(true))
            }
            else {
                return .Failure(lastError)
            }
        }).onSuccess(context: executionContext, callback: { result in
            promise.success(result)
        }).onFailure(context: executionContext, callback: {error in
            promise.failure(error)
        })
        
        return promise.future
    }
    
    // MARK: - Class Methods and properties
    class var singleton: PersistenceManager {
        struct wrap {
            static let single = PersistenceManager()
        }
        return wrap.single
    }
}