//
//  UserDetailMainTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UserDetailMainTableViewCell: UITableViewCell, UserHandlingDelegate {

    // MARK: - Properties
    var userIndex: Int = 0 {
        didSet {
            self.reloadUsersData()
        }
    }
    weak var viewController: UserDetailViewController!
    
    // MARK: Outlets
    @IBOutlet weak var billLabel: UILabel!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadUsersData() {
        let user = User.usersList.list[self.userIndex]
        self.billLabel.text = "\(user.bill)"
    }
    
    // MARK: Actions
    @IBAction func decreaseButtonPressed(sender: AnyObject) {
        let curBill = User.usersList.list[userIndex].bill
        if curBill != 0 {
            self.viewController.billSlider = true
            self.viewController.tableView.reloadData()
        }
    }
    @IBAction func resetButtonPressed(sender: AnyObject) {
        User.usersList.list[userIndex].resetBalance()
        viewController.billSlider = false
        viewController.tableView.reloadData()
        self.reloadUsersData()
    }

}
