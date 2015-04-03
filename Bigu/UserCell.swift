//
//  UserCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/3/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    // MARK: - Properties
    var configured: Bool = false
    var user: User! {
        didSet {
            if user != nil {
                self.configured = true
            }
            self.updateUserInfo()
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateUserInfo()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateUserInfo() {
        if configured {
            self.nameLabel.text = self.user.nickName != "" ? self.user.nickName! : self.user.name
            self.fullnameLabel.text = self.user.fullName
        }
    }
    
    // MARK: Actions
    @IBAction func debitButtonPressed(sender: AnyObject) {
        let currentTaxValue = TaxCell.taxValue
        self.user.debitValue(currentTaxValue)
    }
    
    // MARK: - Class Methods and Properties
    class var userCellReuseId: String {
        return "userCellReuseId"
    }
}
