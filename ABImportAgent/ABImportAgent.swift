//
//  ABImportAgent.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/9/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI
import ExpectedError
import User
import AbstractUser
import UserList
import BrightFutures

public class ABImportAgent: NSObject, ABPeoplePickerNavigationControllerDelegate {
    
    private var controller: UIViewController!
    private var usersHandler: UserHandlingDelegate?
    private var peoplePicker: ABPeoplePickerNavigationController!
    private var onKill: () -> () = {}
    
    // MARK: -Methods
    private func kill() {
        self.onKill()
    }
    
    public func displayPeoplePicker(viewController vc: UIViewController, onKill: () -> (), completion: () -> ()) {
        self.onKill = onKill
        self.controller = vc
        if vc is UserHandlingDelegate {
            self.usersHandler = vc as? UserHandlingDelegate
        }
        if self.peoplePicker == nil {
            self.peoplePicker = ABPeoplePickerNavigationController()
            self.peoplePicker.peoplePickerDelegate = self
        }
        self.peoplePicker.predicateForSelectionOfPerson = NSPredicate(value: true)
        self.controller.presentViewController(self.peoplePicker, animated: true, completion: completion)
    }
    
    // MARK: -Protocols
    // MARK: ABPeoplePickerNavigationControllerDelegate
    public func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        self.kill()
    }
    public func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        
        func registerUser(user newUser: AbstractUser) {
            let usr = newUser as! User
            UserList.sharedUserList.insertUser(usr)
            self.usersHandler?.didRegisterUser?()
        }
        
        let futureAddress = ABImportAgent.peekAddress(viewController: self.controller, person: person)
        let registerFunction: (AbstractUser) -> () = registerUser
        
        let futureUsr = User.loadUserFromAddressBook(viewController: self.controller, person: person, address: futureAddress)
        
        futureUsr.onSuccess{ newUser in
            registerFunction(newUser)
            self.kill()
            }.onFailure{ error in
                let err = error as! ExpectedError
                
                if err.id == NewUserError.codeSet.hasNoAddress.rawValue || err.id == NewUserError.codeSet.choseNoAddress.rawValue{
                    let newUser = error.valueForKey("newUser") as! AbstractUser
                    registerFunction(newUser)
                }
                else if err.id == NewUserError.codeSet.couldNotFindLocation.rawValue {
                    let newUser = error.valueForKey("newUser") as! AbstractUser
                    registerFunction(newUser)
                    
                    let alert = UIAlertController(title: "Could not find location", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(action)
                    self.controller.presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Failed to register user", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(action)
                    self.controller.presentViewController(alert, animated: true, completion: nil)
                }
                
                self.kill()
        }
    }
    
    // MARK: -Class Properties and Methods
    
    class private func peekAddress(viewController vc: UIViewController, person: ABRecord!) -> Future<NSDictionary> {
        
        let addresses: ABMultiValueRef? = ABRecordCopyValue(person, kABPersonAddressProperty)?.takeRetainedValue()
        let count = ABMultiValueGetCount(addresses)
        
        let promise = Promise<NSDictionary>()
        
        if count == 0 {
            promise.failure(NewUserError(description: "user has no address", id: NewUserError.codeSet.hasNoAddress.rawValue))
            return promise.future
        }
        
        let alert = UIAlertController(title: "Select a home address", message: "Select the address to attribute to this profile", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for var i = 0; i < count; i++ {
            let add: NSDictionary! = ABMultiValueCopyValueAtIndex(addresses, i).takeRetainedValue() as? NSDictionary
            
            if add == nil {
                promise.failure(NewUserError(description: "user has no address", id: NewUserError.codeSet.hasNoAddress.rawValue))
                return promise.future
            }
            
            let optionalCountry = add[kABPersonAddressCountryKey as! String] as? String
            let optionalCity = add[kABPersonAddressCityKey as! String] as? String
            let optionalState = add[kABPersonAddressStateKey as! String] as? String
            let optionalZip = add[kABPersonAddressZIPKey as! String] as? String
            let optionalStreet = add[kABPersonAddressStreetKey as! String] as? String
            
            var addressPresentation = ""
            
            if let cur = optionalStreet {
                addressPresentation += cur
            }
            else if let cur = optionalCity {
                addressPresentation += cur
            }
            else if let cur = optionalZip {
                addressPresentation += cur
            }
            else if let cur = optionalState {
                addressPresentation += cur
            }
            else if let cur = optionalCountry {
                addressPresentation += cur
            }
            
            let action = UIAlertAction(title: addressPresentation, style: UIAlertActionStyle.Default, handler: {action in
                promise.success(add!)
            })
            
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Don't Attribute address", style: UIAlertActionStyle.Cancel, handler: { action in
            promise.failure(NewUserError(description: "User chose not to register address", id: NewUserError.codeSet.choseNoAddress.rawValue))
        })
        
        alert.addAction(cancelAction)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            vc.presentViewController(alert, animated: true, completion: nil)
        })
        
        return promise.future
    }
}