//
//  User.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class User: AbstractUser {
    // MARK: -Methods
    func synchronize() {
        User.usersList.insertUser(self)
    }
    
    // MARK: -Class Properties and Methods
    class var usersList: UserList {
        return UserList.sharedUserList
    }
    class func saveToPersistence() {
        let manager = UserPersistenceManager()
        manager.save()
    }
    class func removeUserAtRow (row: Int) {
        UserList.sharedUserList.removeUserAtIndex(row)
    }
}