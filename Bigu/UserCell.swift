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
    internal var configured: Bool {return user != nil}
    internal var user: User! {
        didSet {
            self.updateUserInfo()
        }
    }
    internal var viewController: UIViewController!
    internal var deleteAction: ((sender: AnyObject) -> ())? {
        didSet {
            self.deleteButton.action = self.deleteAction != nil ? self.deleteAction! : {sender in}
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var fullnameLabel: UILabel!
    @IBOutlet weak private var userImageView: UIImageView!
    @IBOutlet weak private var counterView: CounterView!
    private var separator: UIView!
    private var deleteButton: SwipeOptionsButtonItem!
    
    // MARK: - Methods
    
    required internal init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        // buttons
        let button = SwipeOptionsButtonItem(frame: SwipeOptionsButtonItem.frame(forCell: self))
        button.action = { sender in
            self.debitButtonPressed(sender)
        }
        button.setTitle("Cash in", forState: UIControlState.allZeros)
        //105 170 129
        button.backgroundColor = RGBColor(r: 105, g: 170, b: 129, alpha: 1)
        
        self.insertLeftButton(button)
        self.leftButtonFeedbackColor = RGBColor(r: 56, g: 138, b: 109, alpha: 1)
        
        self.deleteButton = SwipeOptionsButtonItem(frame: SwipeOptionsButtonItem.frame(forCell: self))
        self.deleteButton.setTitle("Delete", forState: .allZeros)
        self.deleteButton.backgroundColor = RGBColor(r: 255, g: 58, b: 48, alpha: 1)
        self.insertRightButton(self.deleteButton)
        
        var b = SwipeOptionsButtonItem(frame: SwipeOptionsButtonItem.frame(forCell: self))
        self.insertLeftButton(b)
        b = SwipeOptionsButtonItem(frame: SwipeOptionsButtonItem.frame(forCell: self))
        self.insertRightButton(b)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separator.layoutIfNeeded()
        self.updateCounters()
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
            self.updateCounters()
        }
    }
    
    private func updateCounters() {
        if self.configured {
            self.counterView.count = self.user.history.numberOfRidesForToday()
        }
    }
    
    // MARK: Actions
    @IBAction private func debitButtonPressed(sender: AnyObject) {
        self.user.charge()
        self.updateCounters()
    }
    
    // MARK: - Class Methods and Properties
    class internal var userCellReuseId: String {
        return "userCellReuseId"
    }
}
