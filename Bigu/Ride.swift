//
//  Ride.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UserList
import RootUser

public class Ride {
    // MARK: -Properties
    public let time: NSDate
    public let userId: Int
    public let value: Float
    public var timingSinceOcurrence: NSTimeInterval {
        return self.time.timeIntervalSinceNow
    }
    
    // MARK: -Methods
    public init (userId: Int, value: Float) {
        self.time = NSDate()
        self.userId = userId
        self.value = value
        
        let user = UserList.sharedUserList.list.findBy({ $0.id == self.userId })
    }
    
    internal init(dictionary: [NSString: NSObject]) {
        let optionalTime = dictionary[Ride.timeKey] as? NSDate
        let optionalUser = dictionary[Ride.userKey] as? Int
        let optionalValue = dictionary[Ride.valueKey] as? Float
        
        self.time = optionalTime != nil ? optionalTime! : NSDate(timeIntervalSince1970: 0.0)
        self.userId = optionalUser != nil ? optionalUser! : 0
        self.value = optionalValue != nil ? optionalValue! : 0
    }
    
    public func toDictionary() -> [NSString: NSObject] {
        var dictionary = [NSString: NSObject]()
        dictionary[Ride.userKey] = self.userId
        dictionary[Ride.timeKey] = self.time
        dictionary[Ride.valueKey] = self.value
        return dictionary
    }
    
    // MARK: -Class Properties and Methods
    class private var userKey: String {
        return "RideUserKey"
    }
    class private var timeKey: String {
        return "RideTimeKey"
    }
    class private var valueKey: String {
        return "RideValueKey"
    }
}