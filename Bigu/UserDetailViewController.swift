//
//  UserDetailViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UserDetailViewController: AbstractUserDetailViewController {
    
    // MARK: -Properties
    private var downcastedUser: User {
        return self.user as! User
    }
    private var expensiveUserIndex: Int {
        return User.usersList.list.getObjectIndex(indexFor: self.downcastedUser, compareBy: { $0.id == self.user.id })!
    }
    var billSlider: Bool = false
    
    // MARK: Outlets
    weak var billSliderCell: UserDetailBillSliderTableViewCell?
    
    // MARK: -Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "UserDetailMainTableViewCell", bundle: nil), forCellReuseIdentifier: UserDetailMainTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "UserDetailBillSliderTableViewCell", bundle: nil), forCellReuseIdentifier: UserDetailBillSliderTableViewCell.reuseId)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //persistence
        UserPersistenceManager.singleton.save(nil)
    }
    
    // MARK: -Protocols
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailBillSliderTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailBillSliderTableViewCell
                
                newCell.userIndex = self.expensiveUserIndex
                newCell.mainCell = mainCell
                self.billSliderCell = newCell
                newCell.viewController = self
                
                cell = newCell
            }
        }
        else if section == 1 {
            if row == 0 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailFirstNameTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailFirstNameTableViewCell
                
                newCell.user = self.user
                newCell.userDetailViewController = self
                
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
        }
        else if section == 2 {
            let newCell = tableView.dequeueReusableCellWithIdentifier(RideTableViewCell.reuseId, forIndexPath: indexPath) as! RideTableViewCell
            
            let rideHistory = self.downcastedUser.rideHistory!
            let ride = rideHistory.list.getElementAtIndex(row)
            
            newCell.ride = ride
            
            cell = newCell
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        if section == 0 {
            rows = billSlider ? 2 : 1
        }
        else if section == 1 {
            rows = 3
        }
        else if section == 2 {
            let rideHistory = self.downcastedUser.rideHistory!
            rows = rideHistory.count
        }
        
        return rows
    }
}