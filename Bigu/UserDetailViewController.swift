//
//  UserDetailViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import BrightFutures
import User
import FakeSeparator
import RideTableViewCell
import AbstractUser
import UserList
import UserPersistenceManager
import ExtractViewController

public class UserDetailViewController: AbstractUserDetailViewController {
    
    // MARK: -Properties
    private var downcastedUser: User {
        return self.user as! User
    }
    private var expensiveUserIndex: Int {
        return UserList.sharedUserList.list.getObjectIndex(indexFor: self.downcastedUser, compareBy: { $0.id == self.user.id })!
    }
    private var firstRun: Bool = true
    internal var payingCellIsActive: Bool = false {
        didSet {
            if self.payingCellIsActive {
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
            }
            else if !self.firstRun {
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
            }
            self.firstRun = false
        }
    }
    
    // MARK: Outlets
    weak var payingCell: UserDetailPayingValueTableViewCell?
    
    // MARK: -Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "UserDetailMainTableViewCell", bundle: NSBundle(identifier: "IC.UserDetailViewController")), forCellReuseIdentifier: UserDetailMainTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "UserDetailPayingValueTableViewCell", bundle: NSBundle(identifier: "IC.UserDetailViewController")), forCellReuseIdentifier: UserDetailPayingValueTableViewCell.reuseId)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "BillingHistory"), style: UIBarButtonItemStyle.Plain, target: self, action: "billingHistoryButtonTapped:")
        self.navigationItem.rightBarButtonItem!.imageInsets.top += 5
        self.navigationItem.rightBarButtonItem!.imageInsets.bottom += 5
        self.navigationItem.rightBarButtonItem!.imageInsets.right += 15
        self.navigationItem.rightBarButtonItem!.imageInsets.left -= 5
    }
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //persistence
        UserPersistenceManager.singleton.save(nil)
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == ExtractTableViewController.segueIdentifier {
            let vc = segue.destinationViewController as! ExtractTableViewController
            vc.extractList = self.downcastedUser.history.extractHistory
            vc.title = "Billing History"
        }
    }
    
    public func billingHistoryButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier(ExtractTableViewController.segueIdentifier, sender: sender)
    }
    
    // MARK: -Protocols
    // MARK: UITableViewDataSource
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailMainTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailMainTableViewCell
                newCell.user = self.user
                newCell.viewController = self
                
                mainCell = newCell
                
                cell = newCell
            }
            else if row == 1 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailPayingValueTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailPayingValueTableViewCell
                
                self.payingCell = newCell
                
                cell = newCell
            }
        }
        else if section == 1 {
            if row == 0 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailFirstNameTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailFirstNameTableViewCell
                
                newCell.user = self.user
                newCell.userDetailViewController = self
                self.firstNameCell = newCell
                
                cell = newCell
                
                let separator = FakeSeparator(forView: cell)
                separator.center.x = 0
            }
            else if row == 1 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailLastNameTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailLastNameTableViewCell
                
                newCell.user = self.user
                newCell.userDetailViewController = self
                
                cell = newCell
                
                let separator = FakeSeparator(forView: cell)
                separator.center.x = 0
            }
            else if row == 2 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailNickNameTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailNickNameTableViewCell
                
                newCell.user = self.user
                newCell.userDetailViewController = self
                
                cell = newCell
            }
            else if row == 3 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(MapPinTableViewCell.reuseId, forIndexPath: indexPath) as! MapPinTableViewCell
                
                newCell.pin = self.user.homePin
                
                cell = newCell
            }
        }
        else if section == 2 {
            let newCell = tableView.dequeueReusableCellWithIdentifier(RideTableViewCell.reuseId, forIndexPath: indexPath) as! RideTableViewCell
            
            let rideHistory = self.downcastedUser.history.rideHistory
            let ride = rideHistory.list.getElementAtIndex(row)
            
            newCell.ride = ride
            
            cell = newCell
        }
        
        return cell
    }
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        if section == 0 {
            rows = self.payingCellIsActive ? 2 : 1
        }
        else if section == 1 {
            rows = 4
        }
        else if section == 2 {
            let rideHistory = self.downcastedUser.history.rideHistory
            rows = rideHistory.count
        }
        
        return rows
    }
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        
        if  indexPath.section == 0 && indexPath.row == 1 {
            height = CGFloat(162)
        }
        else if indexPath.section == 1 && indexPath.row == 3 {
            height = CGFloat(160)
        }
        
        return height
    }
    override public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
        
        if cell === self.payingCell {
            (cell as! UserDetailPayingValueTableViewCell).setTaxPickerValue()
        }
        else if indexPath.section == 0 && indexPath.row == 0 {
            let image = (cell as! UserDetailMainTableViewCell).payingButtonImage
            (cell as! UserDetailMainTableViewCell).payButton.setImage(image, forState: .allZeros)
        }
    }
    public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell === self.payingCell {
            let value = (cell as! UserDetailPayingValueTableViewCell).getTaxPickerValue()
            self.downcastedUser.pay(payingValue: value)
        }
    }
}