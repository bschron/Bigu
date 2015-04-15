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
    private func userArrayToDictionaryArray(users: Array<User>) -> [[NSString: NSObject]] {
        var output: [[NSString: NSObject]] = []
        for cur in users {
            let dictionary: [NSString: NSObject] = [UserPersistenceManager.nameKey: cur.name, UserPersistenceManager.surNameKey: cur.surName!, UserPersistenceManager.nickNameKey: cur.nickName!, UserPersistenceManager.billKey: "\(cur.bill)", UserPersistenceManager.userImageKey: UIImagePNGRepresentation(cur.userImage)]
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
    func save() -> Bool {
        let list: Array<User> = (self.object as! UserList).list
        let data: [[NSString: NSObject]] = userArrayToDictionaryArray(list)
        let array =  data as NSArray
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(array, forKey: UserPersistenceManager.usersKey)
        let result = defaults.synchronize()
        
        return result
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
            let billString = cur[UserPersistenceManager.billKey] as! String
            let bill = (billString as NSString).floatValue
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