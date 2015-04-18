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
            let dictionary: [NSString: NSObject] = [UserPersistenceManager.nameKey: cur.name, UserPersistenceManager.surNameKey: cur.surName, UserPersistenceManager.nickNameKey: cur.nickName, UserPersistenceManager.billKey: cur.bill.bill, UserPersistenceManager.userImageKey: UIImagePNGRepresentation(cur.userImage)]
            output += [dictionary]
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
        
        let futureData = future(context: executionContext, { () -> Result<[[NSString: NSObject]]> in
            let list: Array<User> = (self.object as! UserList).list
            let data: [[NSString: NSObject]] = self.userArrayToDictionaryArray(list)
            
            if data.count == list.count {
                return .Success(Box(data))
            }
            else {
                return .Failure(NSError())
            }
        }).onSuccess(context: executionContext, callback: { data in
            let array =  data as NSArray
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(array, forKey: UserPersistenceManager.usersKey)
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
        if storedArray == nil {
            storedArray = []
        }
        var list = UserList()
        
        for cur in storedArray! {
            let name = cur[UserPersistenceManager.nameKey] as! String
            let surName = cur[UserPersistenceManager.surNameKey] as! String
            let nickName = cur[UserPersistenceManager.nickNameKey] as! String
            let bill = cur[UserPersistenceManager.billKey] as! Float
            let dataImage = cur[UserPersistenceManager.userImageKey] as! NSData
            let userImage = UIImage(data: dataImage)
            let newUser = User(name: name, surName: surName, nickName: nickName, bill: bill, userImage: userImage, handler: nil)
            list.insertUser(newUser)
        }
        
        return list
    }
    
    // MARK: - Class Properties and Methods
    class private var usersKey: String {
        return "UsersKey"
    }
    class private var nameKey: String {
        return "UserNameKey"
    }
    class private var surNameKey: String {
        return "UserSurNameKey"
    }
    class private var nickNameKey: String {
        return "UserNickNameKey"
    }
    class private var billKey: String {
        return "UserBillKey"
    }
    class private var userImageKey: String {
        return "UserImageKey"
    }
}
