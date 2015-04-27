//
//  UserDetailFirstNameTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import User
import AbstractUser

public class UserDetailFirstNameTableViewCell: UITableViewCell, UserHandlingDelegate {
    
    // MARK: - Properties
    public var user: AbstractUser! {
        didSet {
            self.reloadUsersData()
        }
    }
    public var userDetailViewController: AbstractUserDetailViewController!
    public var originalFirstName: String?
    
    // MARK: Outlets
    @IBOutlet weak var textField: UITextField!
    public var firstNameIsEmpty: Bool {
        return self.textField.text == ""
    }
    
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
        if newValue != "" {
            self.user.name = newValue
        }
        else {
            self.textField.text = self.originalFirstName
            let alert = UIAlertController(title: "First Name Required", message: "You must provide at least your first name", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK, chill out!", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(action)
            self.userDetailViewController.presentViewController(alert, animated: true, completion: nil)
        }
        if userDetailViewController != nil {
            userDetailViewController.reloadUsersData()
        }
    }
    @IBAction func FirstNameEditingWillBegin(sender: AnyObject) {
        self.originalFirstName = self.textField.text
    }
    @IBAction private func dismissKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    // MARK: -Class Properties and Methods
    class public var reuseId: String {
        return "UserDetailFirstNameCellIdentifier"
    }
}
