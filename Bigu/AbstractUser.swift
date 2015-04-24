//
//  AbstractUser.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/15/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

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
    
    // MARK: -Methods
    public init() {
        self.id = AbstractUser.greaterId++
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    public init(withid id: Int) {
        self.id = id
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    public init(name: String, surName: String?, nickName: String?) {
        self.id = AbstractUser.greaterId++
        self.name = name
        self.surName = surName != nil ? surName! : ""
        self.nickName = nickName != nil ? nickName! : ""
        self.userImage = nil
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    public init(name: String, surName: String?, nickName: String?, userImage: UIImage?) {
        self.id = AbstractUser.greaterId++
        self.name = name
        self.surName = surName != nil ? surName! : ""
        self.nickName = nickName != nil ? nickName! : ""
        self.userImage = userImage
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    public init(id: Int, name: String, surName: String?, nickName: String?, userImage: UIImage?) {
        self.id = id
        self.name = name
        self.surName = surName != nil ? surName! : ""
        self.nickName = nickName != nil ? nickName! : ""
        self.userImage = userImage
        
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
        
        if let image = optionalImage {
            if image == UIImagePNGRepresentation(AbstractUser.emptyUserImage) {
                optionalImage = nil
            }
        }
        
        self.id = optionalId != nil ? optionalId! : AbstractUser.greaterId++
        self.name = optionalName != nil ? optionalName! : "(NULL)"
        self._nickName = optionalNickname
        self._surName = optionalSurname
        self._userImage = optionalImage != nil ? UIImage(data: optionalImage!) : nil
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
        
    }
    
    public func toDictionary() -> [NSString: NSObject] {
        let dictionary: [NSString: NSObject] = [AbstractUser.nameKey: self.name, AbstractUser.surNameKey: self.surName, AbstractUser.nickNameKey: self.nickName, AbstractUser.userImageKey: UIImagePNGRepresentation(self.userImage), AbstractUser.userIdKey : self.id]
        return dictionary
    }
    
    // MARK: -Class Properties and Methods
    private struct greaterIdWrap {
        static var greaterId: Int = 0
    }
    class var greaterId: Int {
        get {
        return User.greaterIdWrap.greaterId
        }
        set {
            User.greaterIdWrap.greaterId = newValue
        }
    }
    class private var usersKey: String {
        return "UsersKey"
    }
    class internal var nameKey: String {
        return "UserNameKey"
    }
    class internal var surNameKey: String {
        return "UserSurNameKey"
    }
    class internal var nickNameKey: String {
        return "UserNickNameKey"
    }
    class internal var userImageKey: String {
        return "UserImageKey"
    }
    class internal var userIdKey: String {
        return "UserIDKey"
    }
    class private var emptyUserImage: UIImage {
        struct wrap {
            static let image: UIImage = UIImage(named: "greenThumbsup")!
        }
        
        return wrap.image
    }
}