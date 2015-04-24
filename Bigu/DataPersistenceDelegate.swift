//
//  DataPersistenceDelegate.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/2/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import BrightFutures

public protocol DataPersistenceDelegate {
    func save (context: ExecutionContext?) -> Future<Bool>
    func load () -> AnyObject?
    var object: AnyObject? {get set}
}