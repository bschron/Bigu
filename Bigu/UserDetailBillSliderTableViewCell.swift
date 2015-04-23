//
//  UserDetailBillSliderTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UserDetailBillSliderTableViewCell: UITableViewCell, BillingHandlerDelegate {
    
    // MARK: - Properties
    var userIndex: Int = 0 {
        didSet {
            self.updateBillingUI()
        }
    }
    var mainCell: UserHandlingDelegate!
    var viewController: UserDetailViewController!
    private var originalBill: Float!
    private var decreasedValue: Float!
    
    // MARK: Outlets
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var billValueLabel: UILabel!

    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        User.usersList.list.getElementAtIndex(self.userIndex)!.registerAsBillHandler(self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateBillingUI() {
        self.originalBill = User.usersList.list.getElementAtIndex(self.userIndex)!.billValue
        self.slider.maximumValue = originalBill
        self.slider.minimumValue = 0
        self.slider.value = originalBill
        self.billValueLabel.text = "\(self.originalBill)"
    }
    
    func zeroValue() {
        let duration = 0.5
        let delay = 0.0 // delay will be 0.0 seconds (e.g. nothing)
        let options = UIViewAnimationOptions.CurveEaseInOut
        
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
            self.slider.value = 0
            }, completion: { finished in
        })
    }
    
    func destroy() {
        if self.viewController.billSlider {
            self.viewController.billSlider = false
            self.viewController.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
            self.viewController.billSliderCell = nil
        }
        (self.viewController.mainCell as! UserDetailMainTableViewCell).registerAsBillingHandler()
    }
    
    // MARK: Actions
    @IBAction func sliderValueChanged(sender: AnyObject) {
        
        let sliderValue = self.slider.value
        let intValue: Int = Int(sliderValue)
        let floatingPointValue = sliderValue - Float(intValue)
        let roundedFloatingPointValue: Float = floatingPointValue >= 0.5 ? 0.5 : 0
        let roundedTotalValue: Float = Float(intValue) + roundedFloatingPointValue
        
        self.decreasedValue = self.originalBill - roundedTotalValue
        self.billValueLabel.text = "\(roundedTotalValue)"
    }
    @IBAction func submitValueDecrease(sender: AnyObject) {
        User.usersList.list.getElementAtIndex(self.userIndex)!.payPartialBill(payingValue: self.decreasedValue)
        self.destroy()
    }
    
    // MARK: -Class Properties and Methods
    class var reuseId: String {
        return "UserDetailTaxSliderCellIdentifier"
    }

}
