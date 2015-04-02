//
//  User.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

class User: Bill {
    // MARK: -Properties
    /* the user's first name */
    var name: String = ""
    /* the user's surname (optional) */
    var surName: String?
    /* the user's full name
    Concept of Computed Properties, a read-only porperties that will return the computed value;
    */
    var fullName: String {
        get {
            return name + " " + (surName != nil ? surName! : "")
        }
    }
    /* the user's nickname (optional) */
    var nickName: String?
    
    // MARK: -Methods
    
    /* the method for creating a empty stance of User */
    override init()
    {
        super.init()
    }
    
    /* the main init method */
    convenience init(name: String, surName: String?, nickName: String?) {
        self.init()
        self.name = name
        self.surName = surName
        self.nickName = nickName
    }
}