//
//  RootUserDetailMainTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/23/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class RootUserDetailMainTableViewCell: AbstractUserDetailMainTableViewCell {
    
    // MARK: -Properties
    private var downcastedUser: RootUser! {
        return self.user as! RootUser
    }
    
    // MARK: Outlets
    @IBOutlet weak var savingsLabel: UILabel!
    
    // MARK: -Methods
    
    // MARK: -Protocols
    // MARK: UserHandlingDelegate
    override func reloadUsersData() {
        super.reloadUsersData()
        self.savingsLabel.text = "\(self.downcastedUser.savings)"
    }
    
    // MARK: -Class Properties and Methods
    override class var reuseId: String {
        return "RootUserDetailMainCell"
    }
}
