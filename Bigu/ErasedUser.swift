//
//  ErasedUser.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/21/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class ErasedUser: User {
    // MARK: -Properties
    override var userImage: UIImage? {
        get {
            return ErasedUser.erasedUserImage
        }
        set {
            super.userImage = nil
        }
    }
    let erasedAt: NSDate
    
    // MARK: - Methods
    init(id: Int, name: String, surName: String?, nickName: String?, erasedAt at: NSDate) {
        self.erasedAt = at
        super.init(withid: id)
        self.name = name
        self.surName = surName != nil ? surName! : ""
        self.nickName = nickName != nil ? nickName! : ""
    }
    
    override init(fromDictionary dic: [NSString : NSObject]) {
        let optionalErasedAt = dic[ErasedUser.erasedAtKey] as? NSDate
        self.erasedAt = optionalErasedAt != nil ? optionalErasedAt! : NSDate()
        let id = dic[User.userIdKey] as? Int
        super.init(withid: id != nil ? id! : 0)
        self.userImage = nil
        
        let optionalName = dic[User.nameKey] as? String
        let optionalsurName = dic[User.surNameKey] as? String
        let optionalNickname = dic[User.nickNameKey] as? String
        
        self.name = optionalName != nil ? optionalName! : "unknown"
        self.surName = optionalsurName != nil ? optionalsurName! : ""
        self.nickName = optionalNickname != nil ? optionalNickname! : ""
    }
    
    override func toDictionary() -> [NSString : NSObject] {
        var dictionary = [NSString: NSObject]()
        
        dictionary[ErasedUser.nameKey] = self.name
        dictionary[ErasedUser.surNameKey] = self.surName
        dictionary[ErasedUser.nickNameKey] = self.nickName
        dictionary[ErasedUser.userIdKey] = self.id
        dictionary[ErasedUser.erasedAtKey] = self.erasedAt
        
        return dictionary
    }
    
    // MARK: -Class Properties and Methods
    class private var erasedAtKey: String {
        return "ErasingDateKey"
    }
    class var erasedUserImage: UIImage {
        struct wrap {
            static let image: UIImage = UIImage(named: "ErasedUserImage")!
        }
        
        return wrap.image
    }
}