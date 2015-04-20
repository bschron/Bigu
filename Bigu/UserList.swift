//
//  UserList.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/3/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

class UserList {
    
    // MARK: -Properties
    private(set) var list: OrderedList<User> = OrderedList<User>(isOrderedBefore: { $0.id < $1.id })
    var order: ((User,User) -> Bool)! {
        didSet {
            self.list.order = self.order
        }
    }
    let defaultOrder: (User, User) -> Bool = { $0.id < $1.id }
    
    // MARK: -Methods
    init() {
        self.order = self.defaultOrder
    }
    init(userArray: [User]) {
        self.order = self.defaultOrder
        self.list.insert(userArray)
    }
    
    func insertUser(newUser: User) {
        self.list.insert(newUser)
    }
    
    func removeUserAtIndex(index: Int) {
        if index < self.list.count {
            self.list.removeAtIndex(index)
        }
    }
    
    func clearList() {
        self.list.clearList()
    }
    
    //MARK: -Class Properties and Methods
    private struct Singleton {
        static var list = UserList()
    }
    class var sharedUserList: UserList {
        get {
            if UserList.singletonWasFreed && UserList.Singleton.list.list.count == 0 {
                let userManager = UserPersistenceManager()
                UserList.Singleton.list = userManager.load() as! UserList
            }
            return UserList.Singleton.list
        }
        set {
            UserList.Singleton.list = newValue
        }
    }
    private struct freedWrap {
        static var freed: Bool = false
    }
    class func freeSingleton(context: ExecutionContext?) {
        let executionContext = context != nil ? context! : Queue.global.context
        future(context: executionContext, { () -> Result<Bool> in
            UserList.sharedUserList.clearList()
            UserList.freedWrap.freed = true
            return .Success(Box(true))
        })
    }
    class var singletonWasFreed: Bool {
        return UserList.freedWrap.freed
    }
}