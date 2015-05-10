//
//  AbstractUser.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/15/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AddressBook
import BrightFutures
import ExpectedError

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
    public var homeLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    public var homePin: MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = self.homeLocation
        pin.title = self.nickName != "" ? self.nickName : self.fullName
        pin.subtitle = (self.nickName != "" ? self.nickName : self.fullName) + "'s home"
        
        return pin
    }
    
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
        let optionalLongitude = dic[AbstractUser.homeLongitudeKey] as? Double
        let optionalLatitude = dic[AbstractUser.homeLatitudeKey] as? Double
        
        if let image = optionalImage {
            if image == UIImagePNGRepresentation(AbstractUser.emptyUserImage) {
                optionalImage = nil
            }
        }
        
        let coordinate: CLLocationCoordinate2D!
        
        if optionalLongitude != nil && optionalLatitude != nil {
            coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(optionalLatitude!), CLLocationDegrees(optionalLongitude!))
        }
        else {
            coordinate = CLLocationCoordinate2DMake(0, 0)
        }
        
        self.id = optionalId != nil ? optionalId! : AbstractUser.greaterId++
        self.name = optionalName != nil ? optionalName! : "(NULL)"
        self._nickName = optionalNickname
        self._surName = optionalSurname
        self._userImage = optionalImage != nil ? UIImage(data: optionalImage!) : nil
        self.homeLocation = coordinate
        
        if self.id >= AbstractUser.greaterId {
            AbstractUser.greaterId = self.id + 1
        }
    }
    
    public func toDictionary() -> [NSString: NSObject] {
        var dictionary = [NSString: NSObject]()
        
        let homeLatitude = Double(self.homeLocation.latitude)
        let homeLongitude = Double(self.homeLocation.longitude)
        
        dictionary[AbstractUser.nameKey] = self.name
        dictionary[AbstractUser.surNameKey] = self.surName
        dictionary[AbstractUser.nickNameKey] = self.nickName
        dictionary[AbstractUser.userImageKey] = UIImagePNGRepresentation(self.userImage)
        dictionary[AbstractUser.userIdKey] = self.id
        dictionary[AbstractUser.homeLatitudeKey] = homeLatitude
        dictionary[AbstractUser.homeLongitudeKey] = homeLongitude
        
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
    class public var homeLongitudeKey: String {
        return "UserHomeLongitudeKey"
    }
    class public var homeLatitudeKey: String {
        return "UserHomeLatitudeKey"
    }
    class private var emptyUserImage: UIImage {
        struct wrap {
            static let image: UIImage = UIImage(named: "whiteUser")!
        }
        
        return wrap.image
    }
    public enum locationState {
        case found
        case multiple
        case notFound
    }
    class public func loadUserFromAddressBook(viewController vc: UIViewController, person: ABRecord!, address add: Future<NSDictionary>) -> Future<AbstractUser> {
        
        let promise = Promise<AbstractUser>()
        
        let recordId = ABRecordGetRecordID(person)
        let firstName: String? = ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as? String
        let lastName: String? = ABRecordCopyValue(person, kABPersonLastNameProperty)?.takeRetainedValue() as? String
        let imageData: NSData? = ABPersonCopyImageData(person)?.takeRetainedValue()
        let image: UIImage?
        
        let addresses: ABMultiValueRef? = ABRecordCopyValue(person, kABPersonAddressProperty)?.takeRetainedValue()
        
        let count = ABMultiValueGetCount(addresses)
        var country: String = ""
        var city: String = ""
        var state: String = ""
        var zip: String = ""
        var street: String = ""
        
        let promisedAddress = Promise<String>()
        if count >= 1 {
            
            let futureAddress = add
            
            futureAddress.onSuccess{ add in
                
                let optionalCountry = add[kABPersonAddressCountryKey as! String] as? String
                let optionalCity = add[kABPersonAddressCityKey as! String] as? String
                let optionalState = add[kABPersonAddressStateKey as! String] as? String
                let optionalZip = add[kABPersonAddressZIPKey as! String] as? String
                let optionalStreet = add[kABPersonAddressStreetKey as! String] as? String
                
                if let cur = optionalCountry {
                    country = cur
                }
                if let cur = optionalCity {
                    city = cur
                }
                if let cur = optionalState {
                    state = cur
                }
                if let cur = optionalZip {
                    zip = cur
                }
                if let cur = optionalStreet {
                    street = cur
                }
                
                promisedAddress.success(street + ", " + city + ", " + state + ", " + zip + ", " + country)
            }.onFailure{ error in
                promisedAddress.failure(error)
            }
        }
        else {
            promisedAddress.failure(NewUserError(description: "user has no address", id: NewUserError.codeSet.hasNoAddress.rawValue))
        }
        
        if let data = imageData {
            image = UIImage(data: data)
        }
            else {
            image = nil
        }
        
        let newUser = AbstractUser(name: firstName != nil ? firstName! : "", surName: lastName, nickName: nil, userImage: image)
        
        promisedAddress.future.onSuccess{ address in
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                
                if let pmCircularRegion = placemark.region as? CLCircularRegion {
                    
                    let metersAcross = pmCircularRegion.radius * 2
                    
                    let region = MKCoordinateRegionMakeWithDistance(pmCircularRegion.center, metersAcross, metersAcross)
                    
                    newUser.homeLocation = pmCircularRegion.center
                    promise.success(newUser)
                }
                
                }
                else {
                    let error = NewUserError(description: "could not find location", id: NewUserError.codeSet.couldNotFindLocation.rawValue)
                    error.setValue(newUser, forKey: "newUser")
                    promise.failure(error)
                }
                })
            }.onFailure{ error in
                let err = error as! ExpectedError
                if err.id == NewUserError.codeSet.hasNoAddress.rawValue || err.id == NewUserError.codeSet.choseNoAddress.rawValue {
                    error.setValue(newUser, forKey: "newUser")
                    promise.failure(error)
                }
        }
        
        return promise.future
    }
}