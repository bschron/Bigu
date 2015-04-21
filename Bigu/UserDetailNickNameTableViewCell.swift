//
//  UserDetailNickNameTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UserDetailNickNameTableViewCell: UITableViewCell, UserHandlingDelegate {
    
    // MARK: - Properties
    var userIndex: Int = 0 {
        didSet {
            self.reloadUsersData()
        }
    }
    var userDetailViewController: UserHandlingDelegate!
    
    // MARK: Outlets
    @IBOutlet weak var textField: UITextField!
    
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
        self.textField.text = User.usersList.list.getElementAtIndex(self.userIndex)!.nickName
    }
    
    // MARK: Actions
    @IBAction func editingDidEnd(sender: AnyObject) {
        let newValue = self.textField.text
        User.usersList.list.getElementAtIndex(self.userIndex)!.nickName = newValue
        if userDetailViewController != nil {
            userDetailViewController.reloadUsersData()
        }
    }
    @IBAction func dismissKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    // MARK: -Class Properties and Methods
    class var reuseId: String {
        return "UserDetailNickNameIdentifier"
    }
}
