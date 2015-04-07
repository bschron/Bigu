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
    private var originalBill: Float!
    
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
        self.originalBill = User.usersList.list[self.userIndex].bill
        self.slider.maximumValue = originalBill
        self.slider.minimumValue = 0
        self.slider.value = originalBill
    }
    
    // MARK: Actions
    @IBAction func sliderValueChanged(sender: AnyObject) {
        
        let sliderValue = self.slider.value
        let intValue: Int = Int(sliderValue)
        let floatingPointValue = sliderValue - Float(intValue)
        let roundedFloatingPointValue: Float = floatingPointValue >= 0.5 ? 0.5 : 0
        let roundedTotalValue: Float = Float(intValue) + roundedFloatingPointValue
        
        User.usersList.list[userIndex].resetBalance()
        User.usersList.list[userIndex].debitValue(roundedTotalValue)
        
        if self.mainCell != nil {
            self.mainCell.reloadUsersData()
        }
    }

}
