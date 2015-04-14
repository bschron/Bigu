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
    private(set) var list: [User]
    
    // MARK: -Methods
    init() {
        self.list = []
    }
    init(userArray: [User]) {
        list = userArray
    }
    
    func insertUser(newUser: User) {
        list += [newUser]
    }
    
    func removeUserAtIndex(index: Int) {
        if index < self.list.count {
            self.list.removeAtIndex(index)
        }
    }
    
    func clearList() {
        self.list = []
    }
    
    //MARK: -Class Propeties and Methods
    private struct Singleton {
        static var list = UserList()
    }
    class var sharedUserList: UserList {
        get {
            return UserList.Singleton.list
        }
        set {
            UserList.Singleton.list = newValue
        }
    }
}