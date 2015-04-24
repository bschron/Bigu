//
//  RootUserDetailViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/23/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit

class RootUserDetailViewController: AbstractUserDetailViewController {
    
    // MARK: -Properties
    private var downcastedUser: RootUser! {
        return self.user as! RootUser
    }
    
    // MARK: Outlets
    internal (set) weak var taxValueCell: RootUserTaxValueTableViewCell?
    
    // MARK: -Methods
    override func viewDidLoad() {
        self.user = RootUser.singleton
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "RootUserDetailMainTableViewCell", bundle: nil), forCellReuseIdentifier: RootUserDetailMainTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "RootUserTaxValueTableViewCell", bundle: nil), forCellReuseIdentifier: RootUserTaxValueTableViewCell.reuseId)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let newTaxValue = taxValueCell?.getTaxPickerValue()
        RootUser.singleton.taxValue = newTaxValue != nil ? newTaxValue! : 0
        
        //persistence
        RootUserPersistenceManager.singleton.save(nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.taxValueCell?.setTaxPickerValue()
    }
    
    // MARK: -Protocols
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
                
                let separator = FakeSeparator(forView: cell)
                separator.center.x = 0
            }
            else if row == 1 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(RootUserTaxValueTableViewCell.reuseId, forIndexPath: indexPath) as! RootUserTaxValueTableViewCell
                
                self.taxValueCell = newCell
                
                cell = newCell
            }
        }
        else if section == 1 {
            if row == 0 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailFirstNameTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailFirstNameTableViewCell
                
                newCell.user = self.user
                newCell.userDetailViewController = self
                
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
        }
        else if section == 2 {
            let newCell = tableView.dequeueReusableCellWithIdentifier(RideTableViewCell.reuseId, forIndexPath: indexPath) as! RideTableViewCell
            
            let rideHistory = RideListManager.rideListSingleton
            let ride = rideHistory.list.getElementAtIndex(row)
            
            newCell.ride = ride
            
            cell = newCell
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        
        if section == 0 {
            rows = 2
        }
        else if section == 1 {
            rows = 3
        }
        else if section == 2 {
            let rideHistory = RideListManager.rideListSingleton
            rows = rideHistory.count
        }
        
        return rows
    }
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        
        if indexPath.section == 0 && indexPath.row == 1 {
            height = CGFloat(100)
        }
        
        return height
    }
}