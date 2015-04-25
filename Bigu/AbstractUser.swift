//
//  AbstractUser.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/15/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit
import History

public class AbstractUser {
    // MARK: -Properties
    private var _name: String?
    public var name: String {
        get {
            return self._name != nil ? self._name! : ""
        }
        set {
            if newValue == "" {
                self._name = nil
            }
            else {
                self._name = newValue
            }
            handler?.reloadUsersData()
        }
    }
    private var _surName: String?
    public var surName: String {
        get {
            return self._surName != nil ? self._surName! : ""
        }
        set {
            if newValue == "" {
                self._surName = nil
            }
            else {
                self._surName = newValue
            }
            handler?.reloadUsersData()
        }
    }
    public var fullName: String {
        get {
            return self.name + ((self.surName != "") ? (" " + self.surName) : (""))
        }
    }
    private var _nickName: String?
    public var nickName: String {
        get {
            return self._nickName != nil ? self._nickName! : ""
        }
        set {
            if newValue == "" {
                self._nickName = nil
            }
            else {
                self._nickName = newValue
            }
            handler?.reloadUsersData()
        }
    }
    private var _userImage: UIImage? = nil
    public var userImage: UIImage? {
        get {
            return self._userImage != nil ? self._userImage! : AbstractUser.emptyUserImage
        }
        set {
            self._userImage = newValue
            handler?.reloadUsersData()
        }
    }
    public var handler: UserHandlingDelegate? = nil
    public let id: Int
    public let history: History
    
    // MARK: -Methods
    public init() {
        self.id = AbstractUser.greaterId++
        self.history = History()
        
        self.history.registerToPersistence()
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    public init(withid id: Int) {
        self.id = id
        self.history = History()
        
        self.history.registerToPersistence()
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    public init(name: String, surName: String?, nickName: String?) {
        self.id = AbstractUser.greaterId++
        self.history = History()
        self.name = name
        self.surName = surName != nil ? surName! : ""
        self.nickName = nickName != nil ? nickName! : ""
        self.userImage = nil
        
        self.history.registerToPersistence()
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    public init(name: String, surName: String?, nickName: String?, userImage: UIImage?) {
        self.id = AbstractUser.greaterId++
        self.history = History()
        self.name = name
        self.surName = surName != nil ? surName! : ""
        self.nickName = nickName != nil ? nickName! : ""
        self.userImage = userImage
        
        self.history.registerToPersistence()
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    public init(id: Int, name: String, surName: String?, nickName: String?, userImage: UIImage?) {
        self.id = id
        self.history = History()
        self.name = name
        self.surName = surName != nil ? surName! : ""
        self.nickName = nickName != nil ? nickName! : ""
        self.userImage = userImage
        
        self.history.registerToPersistence()
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    public init(fromDictionary dic: [NSString: NSObject]) {
        let optionalId = dic[AbstractUser.userIdKey] as? Int
        let optionalName = dic[AbstractUser.nameKey] as? String
        let optionalSurname = dic[AbstractUser.surNameKey] as? String
        let optionalNickname = dic[AbstractUser.nickNameKey] as? String
        var optionalImage = dic[AbstractUser.userImageKey] as? NSData
        let optionalHistoryId = dic[AbstractUser.historyKey] as? Int
        
        if let image = optionalImage {
            if image == UIImagePNGRepresentation(AbstractUser.emptyUserImage) {
                optionalImage = nil
            }
        }
        
        let history: History!
        if let id = optionalHistoryId {
            history = History(fromId: id)
        }
        else {
            history = History()
        }
        
        self.id = optionalId != nil ? optionalId! : AbstractUser.greaterId++
        self.history = history
        self.name = optionalName != nil ? optionalName! : "(NULL)"
        self._nickName = optionalNickname
        self._surName = optionalSurname
        self._userImage = optionalImage != nil ? UIImage(data: optionalImage!) : nil
        
        self.history.registerToPersistence()
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    
    public func toDictionary() -> [NSString: NSObject] {
        var dictionary = [NSString: NSObject]()
        
        dictionary[AbstractUser.nameKey] = self.name
        dictionary[AbstractUser.surNameKey] = self.surName
        dictionary[AbstractUser.nickNameKey] = self.nickName
        dictionary[AbstractUser.userImageKey] = UIImagePNGRepresentation(self.userImage)
        dictionary[AbstractUser.userIdKey] = self.id
        dictionary[AbstractUser.historyKey] = self.history.id
        
        return dictionary
    }
    
    // MARK: -Class Properties and Methods
    private struct greaterIdWrap {
        static var greaterId: Int = 0
    }
    class var greaterId: Int {
        get {
        return AbstractUser.greaterIdWrap.greaterId
        }
        set {
            AbstractUser.greaterIdWrap.greaterId = newValue
        }
    }
    class private var usersKey: String {
        return "UsersKey"
    }
    class public var nameKey: String {
        return "UserNameKey"
    }
    class public var surNameKey: String {
        return "UserSurNameKey"
    }
    class public var nickNameKey: String {
        return "UserNickNameKey"
    }
    class public var userImageKey: String {
        return "UserImageKey"
    }
    class public var userIdKey: String {
        return "UserIDKey"
    }
    class public var historyKey: String {
        return "UserHistoryKey"
    }
    class private var emptyUserImage: UIImage {
        struct wrap {
            static let image: UIImage = UIImage(named: "greenThumbsup")!
        }
        
        return wrap.image
    }
}