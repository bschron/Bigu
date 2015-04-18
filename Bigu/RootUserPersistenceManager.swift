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
            var dictionary: [NSString: NSObject] = [NSString: NSObject]()
            
            dictionary[RootUserPersistenceManager.nameKey] = rootUser.name
            dictionary[RootUserPersistenceManager.lastNameKey] = rootUser.surName
            dictionary[RootUserPersistenceManager.nicknameKey] = rootUser.nickName
            dictionary[RootUserPersistenceManager.userImageKey] = UIImagePNGRepresentation(rootUser.userImage!)
            dictionary[RootUserPersistenceManager.savingsValueKey] = rootUser.savings
            
            if dictionary.count == 5 {
                return .Success(Box(dictionary as NSDictionary))
            }
            else {
                return .Failure(NSError())
            }
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
        
        let rootUser = RootUser.singleton
        
        if storedDictionary != nil {
            let name = storedDictionary![RootUserPersistenceManager.nameKey] as! String
            let lastname = storedDictionary![RootUserPersistenceManager.lastNameKey] as! String
            let nickname = storedDictionary![RootUserPersistenceManager.nicknameKey] as! String
            let savings = storedDictionary![RootUserPersistenceManager.savingsValueKey] as! Float
            let userImage = storedDictionary![RootUserPersistenceManager.userImageKey] as! NSData
            
            rootUser.name = name
            rootUser.surName = lastname
            rootUser.nickName = nickname
            rootUser.savings = savings
            rootUser.userImage = UIImage(data: userImage)
        }
        
        return rootUser
    }
    
    // MARK: -Class Properties and Methods
    class private var nameKey: String {
        return "RootUserNameKey"
    }
    class private var lastNameKey: String {
        return "RootUserLastNameKey"
    }
    class private var nicknameKey: String {
        return "RootUserNickNameKey"
    }
    class private var userImageKey: String {
        return "RootUserImageKey"
    }
    class private var savingsValueKey: String {
        return "RootUserSavingValueKey"
    }
    class private var rootUserKey: String {
        return "RootUserKey"
    }
    class var singleton: RootUserPersistenceManager {
        struct wrap {
            static let single = RootUserPersistenceManager()
        }
        
        return wrap.single
    }
}
