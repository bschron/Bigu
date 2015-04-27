//
//  Extract.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/25/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

public class Extract {
    // MARK: -Properties
    public let userId: Int
    public let value: Float
    public let date: NSDate
    public var secondsSinceOcurrence: NSTimeInterval {
        return self.date.timeIntervalSinceNow
    }
    
    // MARK: -Methods
    public init(userId id: Int, paidValue value: Float) {
        self.userId = id
        self.value = value
        self.date = NSDate()
    }
    
    public init(fromDictionary dic: [NSString: NSObject]) {
        let optionalUserId = dic[Extract.userIdKey] as? Int
        let optionalValue = dic[Extract.valueKey] as? Float
        let optionalDate = dic[Extract.dateKey] as? NSDate
        
        if let id = optionalUserId {
            self.userId = id
        }
        else {
            self.userId = 0
        }
        self.value = optionalValue != nil ? optionalValue! : 0
        self.date = optionalDate != nil ? optionalDate! : NSDate(timeIntervalSinceReferenceDate: 0)
    }
    
    public func toDictionary() -> [NSString: NSObject] {
        var dic = [NSString: NSObject]()
        
        dic[Extract.userIdKey] = self.userId
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