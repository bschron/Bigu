//
//  RootUserPersistenceManager.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class RootUserPersistenceManager: NSObject, DataPersistenceDelegate {
    
    // MARK: - Methods
    override init() {
        super.init()
        PersistenceManager.singleton.registerAsManager(self)
    }
    
    // MARK: - Protocols
    // MARK: DataPersistenceDelegate
    var object: AnyObject? {
        get {
            return RootUser.singleton
        }
        set{}
    }
    
    func save(context: ExecutionContext?) -> Future<Bool> {
        
        let promise = Promise<Bool>()
        var executionContext: ExecutionContext = context != nil ? context!: Queue.global.context
        let rootUser = self.object as! RootUser
        
        let futureData = future(context: executionContext, { () -> Result<NSDictionary> in
            
            var dictionary = rootUser.toDictionary()
            
            return .Success(Box(dictionary as NSDictionary))
        }).onSuccess(context: executionContext, callback: {dictionary in
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(dictionary, forKey: RootUserPersistenceManager.rootUserKey)
            let result = defaults.synchronize()
            
            if !result {
                promise.success(result)
            }
            else {
                promise.failure(NSError())
            }
        }).onFailure(context: executionContext, callback: { error in
            promise.failure(error)
        })
        
        return promise.future
    }
    func load() -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        var storedDictionary = defaults.objectForKey(RootUserPersistenceManager.rootUserKey) as? [NSString: NSObject]
        
        let rootUser: RootUser!
        
        if storedDictionary != nil {
            rootUser = RootUser(fromDictionary: storedDictionary!)
        }
        else {
            rootUser = RootUser()
        }
        
        return rootUser
    }
    
    // MARK: -Class Properties and Methods
    class var singleton: RootUserPersistenceManager {
        struct wrap {
            static let single = RootUserPersistenceManager()
        }
        
        return wrap.single
    }
    class private var rootUserKey: String {
        return "RootUserPersistenceKey"
    }
}
