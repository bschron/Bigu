//
//  UserCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/3/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit
import User
import RGBColor
import FakeSeparator
import UserList
import SwipeOptionsTableViewCell

internal class UserCell: SwipeOptionsTableViewCell {

    // MARK: - Properties
    internal var configured: Bool = false
    internal var user: User! {
        didSet {
            if user != nil {
                self.configured = true
            }
            self.updateUserInfo()
        }
    }
    internal var viewController: UIViewController!
    
    
    //MARK: Outlets
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var fullnameLabel: UILabel!
    @IBOutlet weak private var userImageView: UIImageView!
    private var separator: UIView!
    
    // MARK: - Methods
    
    required internal init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let button = SwipeOptionsButtonItem(frame: SwipeOptionsButtonItem.frame(forCell: self))
        button.action = { sender in
            button.flashActionMark(animated: true)
            self.debitButtonPressed(sender)
            self.restoreCell(true)
        }
        button.setTitle("cash in", forState: UIControlState.allZeros)
        //105 170 129
        button.backgroundColor = RGBColor(r: 105, g: 170, b: 129, alpha: 1)
        
        self.insertLeftButton(button)
    }
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateUserInfo()
        let userImageViewWidth = self.userImageView.frame.width
        self.userImageView.layer.cornerRadius = userImageViewWidth / 2
        self.userImageView.layer.masksToBounds = true
        
        // set background color
        self.contentView.backgroundColor = RGBColor.whiteColor()
        self.separator = FakeSeparator(forView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separator.layoutIfNeeded()
    }

    override internal func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateUserInfo() {
        if configured {
            let user = self.user
            self.nameLabel.text = user.nickName != "" ? user.nickName : user.name
            self.fullnameLabel.text = user.fullName
            self.userImageView.image = user.userImage
        }
    }
    
    // MARK: Actions
    @IBAction private func debitButtonPressed(sender: AnyObject) {
        self.user.charge()
    }
    
    // MARK: - Class Methods and Properties
    class internal var userCellReuseId: String {
        return "userCellReuseId"
    }
}
