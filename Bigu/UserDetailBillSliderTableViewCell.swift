//
//  UserDetailBillSliderTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UserDetailBillSliderTableViewCell: UITableViewCell, UserHandlingDelegate {
    
    // MARK: - Properties
    var userIndex: Int = 0 {
        didSet {
            self.reloadUsersData()
        }
    }
    var mainCell: UserHandlingDelegate!
    
    // MARK: Outlets
    @IBOutlet weak var slider: UISlider!

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
        let bill = user.bill
        slider.maximumValue = bill
        slider.minimumValue = 0
        slider.value = bill
    }
    
    // MARK: Actions
    @IBAction func sliderValueChanged(sender: AnyObject) {
        let bill = User.usersList.list[self.userIndex].bill
        if self.slider.value <= bill {
            User.usersList.list[self.userIndex].creditValue(bill - self.slider.value)
        }
        else {
            User.usersList.list[self.userIndex].debitValue(self.slider.value - bill)
        }
        
        if self.mainCell != nil {
            self.mainCell.reloadUsersData()
        }
    }

}
