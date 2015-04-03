//
//  User.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

class User: BillingProtocol, DataPersistenceDelegate {
    // MARK: -Properties
    private var _name: String?
    var name: String {
        get {
            return _name != nil ? _name! : ""
        }
        set {
            if newValue == "" {
                _name = nil
            }
            else {
                _name = newValue
            }
        }
    }
    private var _surName: String?
    var surName: String? {
        get {
            return _surName != nil ? _surName! : ""
        }
        set {
            if newValue == "" {
                _surName = nil
            }
            else {
                _surName = newValue
            }
        }
    }
    var fullName: String {
        get {
            return name + " " + (surName != nil ? surName! : "")
        }
    }
    private var _nickName: String?
    var nickName: String? {
        get {
            return _nickName != nil ? _nickName! : ""
        }
        set {
            if newValue == "" {
                _nickName = nil
            }
            else {
                _nickName = newValue
            }
        }
    }
    
    
    // MARK: -Methods
    init() {}
    init(name: String, surName: String?, nickName: String?, handler: BillingHandlerDelegate?) {
        self.name = name
        self.surName = surName
        self.nickName = nickName
        self.handler = handler
        User.storedUsersTable(self, clear: false)
    }
    
    // MARK: -Protocols
    // MARK: BillingProtocol
    private var _bill: Float?
    var bill: Float {
        get {
            return _bill != nil ? _bill! : 0
        }
    }
    var handler: BillingHandlerDelegate?
    func creditValue(value: Float) {
        _bill = (_bill != nil ? _bill! : 0) + value
    }
    func debitValue(value: Float) {
        _bill = (_bill != nil ? _bill! : 0) + value
        if _bill == 0 {
            _bill = nil
        }
    }
    func resetBalance() {
        _bill = nil
    }
    // MARK: DataPersistenceDelegate
    var object: AnyObject? {
        get {
            return User.storedUsersTable(nil, clear: false)
        }
        set {}
    }
    func save() -> Bool {
        let users = User.storedUsersTable(nil, clear: false)
        var data: [[String: AnyObject]] = userArrayToDictionaryArray(users)
        let array = data as NSArray
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(array, forKey: User.usersKey)
        let result = defaults.synchronize()
        
        return result
    }
    func load() -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let storedArray = defaults.objectForKey(User.usersKey) as? [[String: AnyObject]]
        return storedArray
    }
    private func userArrayToDictionaryArray(users: Array<User>) -> [[String: AnyObject]] {
        var output: [[String: AnyObject]] = []
        for cur in users {
            let dictionary: [String: AnyObject] = [User.nameKey: self.name, User.surNameKey: self.surName!, User.nickNameKey: self.nickName!, User.billKey: self.bill]
            output += [dictionary]
        }
        return output
    }
    
    // MARK: -Class Properties and Methods
    class private func storedUsersTable(newUser: User?, clear: Bool) -> Array<User> {
        struct storedValue {
            static var usersTable: Array<User> = []
        }
        
        if newUser != nil {
            storedValue.usersTable += [newUser!]
        }
        
        if clear {
            storedValue.usersTable = []
        }
        
        return storedValue.usersTable
    }
    class var usersTable: Array<User> {
        return storedUsersTable(nil, clear: false)
    }
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
    class func initFromPersistence() {
        let randomUser = User()
        let array = randomUser.load() as? [[String: AnyObject]]
        User.storedUsersTable(nil, clear: true)
        if array != nil {
            for cur in array! {
                let name = cur[User.nameKey] as String
                let surName = cur[User.surNameKey] as String
                let nickName = cur[User.nickNameKey] as String
                let bill = cur[User.nickNameKey] as String
                let newUser = User(name: name, surName: surName, nickName: nickName, handler: nil)
            }
        }
    }
}