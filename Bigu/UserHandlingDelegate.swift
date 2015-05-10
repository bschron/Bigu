//
//  UserHandlingDelegate.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/4/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

@objc public protocol UserHandlingDelegate {
    func reloadUsersData()
    optional func didRegisterUser()
}