//
//  RootUserDetailViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/23/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit
import BrightFutures
import User
import FakeSeparator
import RideTableViewCell
import AbstractUser
import RootUser
import Ride
import Billing
import History

public class RootUserDetailViewController: AbstractUserDetailViewController {
    
    // MARK: -Properties
    private var downcastedUser: RootUser! {
        return self.user as! RootUser
    }
    private var downcastedMainCell: RootUserDetailMainTableViewCell! {
        return self.mainCell as! RootUserDetailMainTableViewCell
    }
    private var firstRun: Bool = true
    internal var shouldDisplayTaxValueCell: Bool = false {
        didSet {
            if self.shouldDisplayTaxValueCell {
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
            }
            else if !self.firstRun {
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
            }
            self.firstRun = false
        }
    }
    
    // MARK: Outlets
    internal (set) weak var taxValueCell: RootUserTaxValueTableViewCell?
    
    // MARK: -Methods
    override public func viewDidLoad() {
        self.user = RootUser.singleton
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "RootUserDetailMainTableViewCell", bundle: NSBundle(identifier: "IC.UserDetailViewController")), forCellReuseIdentifier: RootUserDetailMainTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "RootUserTaxValueTableViewCell", bundle: NSBundle(identifier: "IC.UserDetailViewController")), forCellReuseIdentifier: RootUserTaxValueTableViewCell.reuseId)
    }
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let newTaxValue = taxValueCell?.getTaxPickerValue()
        if let value = newTaxValue {
            Bill.taxValue = value
        }
        //persistence
        RootUserPersistenceManager.singleton.save(nil)
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.taxValueCell?.setTaxPickerValue()
    }
    
    // MARK: -Protocols
    // MARK: UITableViewDataSource
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(RootUserDetailMainTableViewCell.reuseId, forIndexPath: indexPath) as! RootUserDetailMainTableViewCell
                newCell.user = self.user
                newCell.viewController = self
                
                self.mainCell = newCell
                
                cell = newCell
            }
            else if row == 1 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(RootUserTaxValueTableViewCell.reuseId, forIndexPath: indexPath) as! RootUserTaxValueTableViewCell
                
                self.taxValueCell = newCell
                newCell.removeFromTableView = {
                    self.shouldDisplayTaxValueCell = false
                }
                
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
            }
            else if row == 1 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailLastNameTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailLastNameTableViewCell
                
                newCell.user = self.user
                newCell.userDetailViewController = self
                
                cell = newCell
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
            
            let rideHistory = History.singleton.rideHistory
            let ride = rideHistory.list.getElementAtIndex(row)
            
            newCell.ride = ride
            
            cell = newCell
        }
        
        return cell
    }
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        
        if section == 0 {
            rows = self.shouldDisplayTaxValueCell ? 2 : 1
        }
        else if section == 1 {
            rows = 4
        }
        else if section == 2 {
            let rideHistory = History.singleton.rideHistory
            rows = rideHistory.count
        }
        
        return rows
    }
    // MARK: UITableViewDelegate
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        
        if indexPath.section == 0 && indexPath.row == 1 {
            height = CGFloat(162)
        }
        else if indexPath.section == 1 && indexPath.row == 3 {
            height = CGFloat(160)
        }
        
        return height
    }
    override public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
        if indexPath.section == 0 && indexPath.row == 1 {
            if indexPath.row == 0 {
                self.downcastedMainCell.taxValueButton.setImage(self.downcastedMainCell.taxButtonImage, forState: .allZeros)
            }
            else if indexPath.row == 1 {
                self.taxValueCell?.setTaxPickerValue()
            }
        }
    }
}