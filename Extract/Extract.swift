//
//  Extract.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/25/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import AbstractUser

public class Extract {
    // MARK: -Properties
    public let user: AbstractUser?
    public let value: Float
    public let date: NSDate
    
    // MARK: -Methods
    public init(user: AbstractUser, paidValue value: Float) {
        self.user = user
        self.value = value
        self.date = NSDate()
    }
    
    public init(fromDictionary dic: [NSString: NSObject]) {
        let optionalUserId = dic[Extract.userIdKey] as? Int
        let optionalValue = dic[Extract.valueKey] as? Float
        let optionalDate = dic[Extract.dateKey] as? NSDate
        
        self.user = AbstractUser()
        self.value = 1
        self.date = NSDate()
    }
    
    public func toDictionary() -> [NSString: NSObject] {
        var dic = [NSString: NSObject]()
        
        dic[Extract.userIdKey] = self.user?.id
        dic[Extract.valueKey] = self.value
        dic[Extract.dateKey] = self.date
        
        return dic
    }
    
    // MARK: -Class Properties and Methods
    class private var userIdKey: String {
        return "ExtractUserIdKey"
    }
    class private var valueKey: String {
        return "ExtractValueKey"
    }
    class private var dateKey: String {
        return "ExtractDateKey"
    }
}