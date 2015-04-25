//
//  AbstractUserDetailMainTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/22/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Models

internal class AbstractUserDetailMainTableViewCell: UITableViewCell, UserHandlingDelegate {

    // MARK: - Properties
    internal var user: AbstractUser! {
        didSet {
            self.reloadUsersData()
        }
    }
    weak var viewController: AbstractUserDetailViewController!
    @IBOutlet weak var userImageView: UIImageView!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let userImageViewWidth = self.userImageView.frame.width
        self.userImageView.layer.cornerRadius = userImageViewWidth / 2
        self.userImageView.layer.masksToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    internal func reloadUsersData() {
        self.userImageView.image = self.user.userImage
    }
    
    // MARK: Actions
    @IBAction private func loadImage(sender: AnyObject) {
        self.viewController.displayPhotoLibraryPicker()
    }
    
    // MARK: -Class Properties and Methods
    class internal var reuseId: String {
        return "AbstractUserDetailMainCellIdentifier"
    }
    
}