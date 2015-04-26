//
//  UserDetailMainTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import AbstractUser
import Models
import Billing

internal class UserDetailMainTableViewCell: AbstractUserDetailMainTableViewCell, BillingHandlerDelegate {
    
    // MARK: -Properties
    override var user: AbstractUser! {
        didSet {
            self.reloadUsersData()
            self.registerAsBillingHandler()
        }
    }
    private var downcastedUser: User! {
        return self.user as! User
    }
    private var downcastedViewController: UserDetailViewController {
        return self.viewController as! UserDetailViewController
    }
    internal var payingButtonImage: UIImage {
        get {
            let image: UIImage!
            if self.downcastedViewController.payingCellIsActive {
                image = UIImage(named:"pay")
            }
            else {
                image = UIImage(named:"pay(highlighted)")
            }
            return image
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak private var billLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    // MARK: -Methods
    internal func updateBillingUI() {
        self.billLabel.text = "\(self.downcastedUser.billValue)"
    }
    
    internal func registerAsBillingHandler() {
        self.downcastedUser.registerAsBillHandler(self)
    }
    
    // MARK: Actions
    @IBAction func payButtonPressed(sender: AnyObject) {
        self.downcastedViewController.payingCellIsActive = !self.downcastedViewController.payingCellIsActive
        self.payButton.setImage(self.payingButtonImage, forState: .allZeros)
    }
    
    // MARK; -Class Properties and Methods
    override internal class var reuseId: String {
        return "UserDetailMainCellIdentifier"
    }
}
