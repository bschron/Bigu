//
//  UsersViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import User
import UserDetailViewController
import AbstractUser
import UserList
import AddressBook
import AddressBookUI
import MapKit
import BrightFutures
import ExpectedError

public class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserHandlingDelegate, ABPeoplePickerNavigationControllerDelegate {

    // MARK: - Proprierties
    private weak var popUp: NewUserPopUp?
    internal var peoplePicker: ABPeoplePickerNavigationController?
    
    //MARK: Outlets
    @IBOutlet weak var usersTableView: UITableView!
    
    // MARK: - Methods
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.usersTableView.backgroundColor = UIColor.whiteColor()
        self.usersTableView.separatorStyle = .None
        
        /* register user cells nibs */
        let userCellNib = UINib(nibName: "UserCell", bundle: NSBundle(identifier: "IC.UsersViewController"))
        self.usersTableView.registerNib(userCellNib, forCellReuseIdentifier: UserCell.userCellReuseId)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.usersTableView.reloadData()
        self.reloadUsersData()
    }
    
    func freePopUp() {
        if self.popUp != nil {
            self.popUp!.terminate()
            self.popUp = nil
        }
    }
    
    internal func displayPeoplePicker() {
        if self.peoplePicker == nil {
            self.peoplePicker = ABPeoplePickerNavigationController()
            self.peoplePicker!.peoplePickerDelegate = self
        }
        self.presentViewController(self.peoplePicker!, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func addUserButtonPressed(sender: AnyObject) {
        
        if self.popUp != nil {
            self.popUp!.tryToAddUserWithProvidedInfo()
            self.freePopUp()
            return
        }
        
        self.popUp = NewUserPopUp.addPopUpToView(aViewController: self, usersHandler: self) as? NewUserPopUp
        self.popUp!.alpha = CGFloat(0)
        self.popUp!.blurView?.alpha = CGFloat(0)
        UIView.animateWithDuration(0.25
            , delay: 0.0, options: UIViewAnimationOptions.LayoutSubviews | UIViewAnimationOptions.CurveLinear, animations: {
                self.popUp!.alpha = CGFloat(1)
                self.popUp!.blurView?.alpha = CGFloat(1)
            }, completion: {result in})
    }
    
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if let pop = self.popUp {
            pop.transitionToSize(size)
        }
    }
    
    // MARK: Navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == UsersViewController.userDetailSegueIdentifier {
            let vc = segue.destinationViewController as! UserDetailViewController
            let senderCell = sender as! UserCell
            let userName = senderCell.user.nickName != "" ? senderCell.user.nickName : senderCell.user.name
            
            vc.title = userName
            vc.user = senderCell.user
        }
    }
    
    // MARK: -Protocols
    
    // MARK: TableViewDataSource
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserList.sharedUserList.list.count
    }
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = usersTableView.dequeueReusableCellWithIdentifier(UserCell.userCellReuseId, forIndexPath: indexPath) as! UserCell
        cell.user = UserList.sharedUserList.list.getElementAtIndex(indexPath.row)!
        cell.viewController = self
        
        return cell
    }
    
    // MARK: TableViewDelegate
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(80)
    }
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var result: Bool!
        
        if tableView === self.usersTableView {
            result = true
        }
        else {
            result = false
        }
        
        return result
    }
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView === self.usersTableView {
            if editingStyle == .Delete {
                UserList.sharedUserList.removeUserAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        let cell = self.usersTableView.cellForRowAtIndexPath(indexPath)
        
        self.performSegueWithIdentifier(UsersViewController.userDetailSegueIdentifier, sender: cell)
    }
    
    // MARK: ABPeoplePickerNavigationControllerDelegate
    public func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
    }
    public func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        
        func registerUser(user newUser: AbstractUser) {
            let usr = newUser as! User
            UserList.sharedUserList.insertUser(usr)
            self.usersTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.usersTableView.numberOfRowsInSection(0), inSection: 0)], withRowAnimation: .Automatic)
        }
        
        self.popUp?.terminate()
        
        let futureAddress = UsersViewController.peekAddress(viewController: self, person: person)
        let registerFunction: (AbstractUser) -> () = registerUser
        
        let futureUsr = User.loadUserFromAddressBook(viewController: self, person: person, address: futureAddress)
        futureUsr.onSuccess{ newUser in
            registerFunction(newUser)
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
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "No Result for this address", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: UserHandlingDelegate
    public func reloadUsersData() {
        self.usersTableView.reloadData()
    }
    
    // MARK: - Class Properties
    class var userDetailSegueIdentifier: String {
        return "UserDetailSegue"
    }
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
