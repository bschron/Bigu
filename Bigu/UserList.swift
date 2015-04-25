//
//  UserList.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/3/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import BrightFutures
import Collection

public class UserList {
    
    // MARK: -Properties
    public private(set) var list: OrderedList<User> = OrderedList<User>(isOrderedBefore: { $0.id < $1.id })
    public private(set) var erasedUsersList: OrderedList<ErasedUser> = OrderedList<ErasedUser>(isOrderedBefore: { $0.erasedAt.timeIntervalSinceNow > $1.erasedAt.timeIntervalSinceNow })
    internal var order: ((User,User) -> Bool)! {
        didSet {
            self.list.order = self.order
        }
    }
    private let defaultOrder: (User, User) -> Bool = { $0.id < $1.id }
    internal var isLoading: Bool = false
    
    // MARK: -Methods
    public init() {
        self.order = self.defaultOrder
    }
    public init(userArray: [User]) {
        self.order = self.defaultOrder
        self.list.insert(userArray)
        // if should save to defaults
        if !isLoading && self === UserList.Singleton.list {
            UserPersistenceManager.singleton.save(nil)
        }
    }
    
    public func insertUser(newUser: User) {
        self.list.insert(newUser)
        // if should save to defaults
        if !isLoading && self === UserList.Singleton.list {
            UserPersistenceManager.singleton.save(nil)
        }
    }
    
    public func insertErasedUser(erasedUser: ErasedUser) {
        self.erasedUsersList.insert(erasedUser)
    }
    
    public func removeUserAtIndex(index: Int) {
        if index < self.list.count {
            let toErase = self.list.getElementAtIndex(index)!
            toErase.rideHistory?.unregisterSelfId()
            toErase.rideHistory = nil
            self.list.removeAtIndex(index)
            let erased = ErasedUser(id: toErase.id, name: toErase.name, surName: toErase.surName, nickName: toErase.nickName, erasedAt: NSDate())
            self.erasedUsersList.insert(erased)
            // if its the sigleton list
            if self === UserList.Singleton.list {
                UserPersistenceManager.singleton.save(nil)
            }
        }
    }
    
    public func clearList() {
        self.list.clearList()
    }
    
    //MARK: -Class Properties and Methods
    private struct Singleton {
        static var list = UserList()
    }
    class public var sharedUserList: UserList {
        get {
            if UserList.singletonWasFreed && UserList.Singleton.list.list.count == 0 {
                let userManager = UserPersistenceManager.singleton
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
    class public func freeSingleton(context: ExecutionContext?) {
        let executionContext = context != nil ? context! : Queue.global.context
        future(context: executionContext, { () -> Result<Bool> in
            UserList.sharedUserList.clearList()
            UserList.freedWrap.freed = true
            return .Success(Box(true))
        })
    }
    class internal var singletonWasFreed: Bool {
        return UserList.freedWrap.freed
    }
}