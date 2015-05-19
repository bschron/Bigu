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
import ABImportAgent

public class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserHandlingDelegate {

    // MARK: - Proprierties
    private weak var popUp: NewUserPopUp?
    private var agent: ABImportAgent?
    
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
        self.agent = ABImportAgent()
        self.agent?.displayPeoplePicker(viewController: self, onKill: {}, completion: {
            self.freePopUp()
        })
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
        let deleteAction:(sender: AnyObject) -> () = { sender in
            self.tableView(self.usersTableView, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: self.usersTableView.indexPathForCell(cell)!)
        }
        cell.deleteAction = deleteAction
        
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
    
    // MARK: UserHandlingDelegate
    public func reloadUsersData() {
        self.usersTableView.reloadData()
    }
    
    public func didRegisterUser() {
        let rows = UserList.sharedUserList.list.count - 1
        let index = NSIndexPath(forRow: rows, inSection: 0)
        self.usersTableView.insertRowsAtIndexPaths([index], withRowAnimation: .Automatic)
    }
    
    // MARK: - Class Properties
    class var userDetailSegueIdentifier: String {
        return "UserDetailSegue"
    }
}
