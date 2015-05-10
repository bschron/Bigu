//
//  ExpectedError.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/9/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

public class ExpectedError: NSError {
    private var _id: Int?
    private var _description: String?
    private var storedValues: [String: AnyObject]? = nil
    
    public var id: Int {
        get {
            let output: Int!
            if self._id == nil {
                output = 0
            }
            else {
                output = self._id
            }
            return output
        }
    }
    override public var description: String {
        get {
            let output: String!
            if self._description == nil {
                output = ""
            }
            else {
                output = self._description
            }
            return output
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(description: String, id: Int) {
        super.init(domain: "", code: 0, userInfo: ["":""])
        self._id = id
        self._description = description
    }
    
    public override func valueForKey(key: String) -> AnyObject? {
        var value: AnyObject?
        
        if let dic = self.storedValues {
            value = dic[key]
        }
        
        return value
    }
    
    public override func setValue(value: AnyObject?, forKey key: String) {
        if self.storedValues == nil {
            self.storedValues = [String: AnyObject]()
        }
        
        self.storedValues![key] = value
    }
    
    class public var type: String {
        return "ExpectedError"
    }
}