//
//  UserDetailPayingValueTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/26/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

internal class UserDetailPayingValueTableViewCell: RootUserTaxValueTableViewCell {
    // MARK: -Properties
    override internal var intergerValues: Array<Int> {
        get {
            var array = Array<Int>()
            for var i = 0; i <= 100; i++ {
                array += [i]
            }
            return array
        }
    }
    override internal var floatingValues: [Float] {
        get {
            var array = Array<Float>()
            for var i: Float = 0; i < 100; i += 5 {
                array += [i / 100]
            }
            return array
        }
    }
    override internal var sourceTaxValue: Float {
        return 0.0
    }
    
    // MARK: -Methods
    override internal func awakeFromNib() {
        super.awakeFromNib()
        self.label.text = "Paying Value"
    }
    
    // MARK: -Protocols
    // MARK: UIPickerViewDelegate
    override func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title: NSAttributedString?
        
        if component == 0 {
            title = NSAttributedString(string: "\(self.intergerValues[row])")
        }
        else {
            let value = Int(self.floatingValues[row] * 100)
            title = NSAttributedString(string: String(format: ".%.2d", value))
        }
        
        return title
    }
    
    // MARK: -Class Properties and Methods
    override class internal var reuseId: String {
        return "UserDetailTaxValueCell"
    }
}