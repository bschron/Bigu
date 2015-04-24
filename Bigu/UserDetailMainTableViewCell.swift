//
//  UserDetailMainTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Models

class UserDetailMainTableViewCell: AbstractUserDetailMainTableViewCell, BillingHandlerDelegate {
    
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
    
    // MARK: Outlets
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    // MARK: -Methods
    func updateBillingUI() {
        
        self.billLabel.text = "\(self.downcastedUser.billValue)"
        if self.downcastedUser.billValue <= 0 {
            self.resetButton.hidden = true
            self.decreaseButton.hidden = true
        }
        else {
            self.resetButton.hidden = false
            self.decreaseButton.hidden = false
        }
    }
    
    func registerAsBillingHandler() {
        self.downcastedUser.registerAsBillHandler(self)
    }
    
    // MARK: Actions
    @IBAction func decreaseButtonPressed(sender: AnyObject) {
        let curBill: Float = self.downcastedUser.billValue
        if curBill != 0 && !self.downcastedViewController.billSlider {
            self.downcastedViewController.billSlider = true
            self.viewController.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.viewController.tableView.reloadData()
        }
        else if self.downcastedViewController.billSlider {
            self.downcastedViewController.billSliderCell?.destroy()
        }
    }
    @IBAction func resetButtonPressed(sender: AnyObject) {
        self.downcastedUser.payBill()
        self.registerAsBillingHandler()
        self.downcastedViewController.billSliderCell?.destroy()
    }
    
    // MARK; -Class Properties and Methods
    override class var reuseId: String {
        return "UserDetailMainCellIdentifier"
    }
}
