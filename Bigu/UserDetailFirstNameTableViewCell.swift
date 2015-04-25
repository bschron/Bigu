//
//  UserDetailFirstNameTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Models

public class UserDetailFirstNameTableViewCell: UITableViewCell, UserHandlingDelegate {
    
    // MARK: - Properties
    public var user: AbstractUser! {
        didSet {
            self.reloadUsersData()
        }
    }
    public var userDetailViewController: UserHandlingDelegate!
    
    // MARK: Outlets
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Methods

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func reloadUsersData() {
        self.textField.text = self.user.name
    }
    
    // MARK: Actions
    @IBAction private func editingDidEnd(sender: AnyObject) {
        let newValue = self.textField.text
        self.user.name = newValue
        if userDetailViewController != nil {
            userDetailViewController.reloadUsersData()
        }
    }
    @IBAction private func dismissKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    // MARK: -Class Properties and Methods
    class public var reuseId: String {
        return "UserDetailFirstNameCellIdentifier"
    }
}
