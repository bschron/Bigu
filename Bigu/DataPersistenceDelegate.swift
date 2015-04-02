//
//  DataPersistenceDelegate.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/2/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

protocol DataPersistenceDelegate {
    func save () -> Bool
    func load () -> AnyObject?
    var object: AnyObject? {get set}
}