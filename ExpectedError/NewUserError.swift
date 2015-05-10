//
//  NewUserError.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/9/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

public class NewUserError: ExpectedError {
    override public class var type: String {
        return "NewUserError"
    }
    
    public enum codeSet: Int {
        case hasNoAddress
        case choseNoAddress
        case couldNotFindLocation
    }
}