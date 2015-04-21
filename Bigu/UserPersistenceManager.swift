//
//  UserPersistenceManager.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/14/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class UserPersistenceManager: NSObject, DataPersistenceDelegate {
    
    // MARK: - Properties
    
    // MARK: - Methods
    
    override init() {
        super.init()
        PersistenceManager.singleton.registerAsManager(self)
    }
    
    private func userArrayToDictionaryArray(users: Array<User>) -> [[NSString: NSObject]] {
        var output: [[NSString: NSObject]] = []
        for cur in users {
            output += [cur.toDictionary()]
        }
        return output
    }
    
    // MARK: - Protocols
    // MARK: DataPersistenceDelegate
    var object: AnyObject? {
        get {
            return User.usersList
        }
        set {}
    }
    func save(context: ExecutionContext?) -> Future<Bool> {
        
        let promise = Promise<Bool>()
        var executionContext: ExecutionContext = context != nil ? context! : Queue.global.context
        
        let futureData = future(context: executionContext, { () -> Result<([[NSString: NSObject]], [[NSString: NSObject]])> in
            let list: Array<User> = (self.object as! UserList).list.arrayCopy()
            let erasedList: Array<ErasedUser> = (self.object as! UserList).erasedUsersList.arrayCopy()
            let data: [[NSString: NSObject]] = self.userArrayToDictionaryArray(list)
            let erasedUsersData: [[NSString: NSObject]] = self.userArrayToDictionaryArray(erasedList)
            
            let dataTuple = (data, erasedUsersData)
            
            if data.count == list.count && erasedList.count == erasedUsersData.count {
                return .Success(Box(dataTuple))
            }
            else {
                return .Failure(NSError())
            }
        }).onSuccess(context: executionContext, callback: { data in
            var array =  data.0 as NSArray
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(array, forKey: UserPersistenceManager.usersKey)
            array = data.1
            defaults.setObject(array, forKey: UserPersistenceManager.erasedUsersKey)
            let result = defaults.synchronize()
            
            if !result {
                promise.success(result)
            }
            else {
                promise.failure(NSError())
            }
        }).onFailure(context: executionContext, callback: { error in
            promise.failure(NSError())
        })
        
        
        return promise.future
    }
    func load() -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        var storedArray = defaults.objectForKey(UserPersistenceManager.usersKey) as? [[NSString: NSObject]]
        var storedErasedUsersArray = defaults.objectForKey(UserPersistenceManager.erasedUsersKey) as? [[NSString: NSObject]]
        if storedArray == nil {
            storedArray = []
        }
        if storedErasedUsersArray == nil {
            storedErasedUsersArray = []
        }
        
        var list = UserList()
        
        for cur in storedArray! {
            let newUser = User(fromDictionary: cur)
            list.insertUser(newUser)
        }
        for cur in storedErasedUsersArray! {
            let erasedUser = ErasedUser(fromDictionary: cur)
            list.insertErasedUser(erasedUser)
        }
        
        return list
    }
    
    // MARK: - Class Properties and Methods
    class private var usersKey: String {
        return "UsersKey"
    }
    class private var erasedUsersKey: String {
        return "ErasedUsersKey"
    }
}
