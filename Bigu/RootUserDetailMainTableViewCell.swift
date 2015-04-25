//
//  RootUserDetailMainTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/23/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Models
import AbstractUser

internal class RootUserDetailMainTableViewCell: AbstractUserDetailMainTableViewCell {
    
    // MARK: -Properties
    private var downcastedUser: RootUser! {
        return self.user as! RootUser
    }
    internal var downcastedViewController: RootUserDetailViewController! {
        return self.viewController as! RootUserDetailViewController
    }
    internal var taxButtonImage: UIImage {
        get {
            let image: UIImage!
            if self.downcastedViewController.shouldDisplayTaxValueCell {
                image = UIImage(named: "taxValue(highlighted)")
            }
            else {
                image = UIImage(named: "taxValue")
            }
            return image
        }
    }
    
    // MARK: Outlets
    @IBOutlet private weak var savingsLabel: UILabel!
    @IBOutlet internal weak var taxValueButton: UIButton!
    
    // MARK: -Methods
    override internal func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction internal func taxButtonPressed(sender: AnyObject) {
        self.downcastedViewController.shouldDisplayTaxValueCell = !self.downcastedViewController.shouldDisplayTaxValueCell
        self.taxValueButton.setImage(self.taxButtonImage, forState: UIControlState.allZeros)
    }
    
    // MARK: -Protocols
    // MARK: UserHandlingDelegate
    override internal func reloadUsersData() {
        super.reloadUsersData()
        self.savingsLabel.text = "\(self.downcastedUser.savings)"
    }
    
    // MARK: -Class Properties and Methods
    override class internal var reuseId: String {
        return "RootUserDetailMainCell"
    }
}
