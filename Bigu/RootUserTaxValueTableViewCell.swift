//
//  RootUserTaxValueTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/23/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Foundation

class RootUserTaxValueTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: -Properties
    private var _intValues: Array<Int>?
    private var intergerValues: Array<Int> {
        get {
            if self._intValues == nil {
                var array: Array<Int> = []
                for var i = 0; i <= 50; i++ {
                    array += [i]
                }
                self._intValues = array
            }
            
            return self._intValues!
        }
    }
    private var floatingValues: [Float] = [0.0, 0.5]
    
    // MARK: Outlets
    @IBOutlet weak var taxValuePickerView: UIPickerView!
    
    // MARK: -Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.taxValuePickerView.dataSource = self
        self.taxValuePickerView.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getTaxPickerValue() -> Float {
        let intValueRow = self.taxValuePickerView.selectedRowInComponent(0)
        let intValue = self.intergerValues[intValueRow]
        let floatValueRow = self.taxValuePickerView.selectedRowInComponent(1)
        let floatValue = self.floatingValues[floatValueRow]
        let totalValue = Float(intValue) + floatValue
        return totalValue
    }
    
    // MARK: -Protocols
    // MARK: UIPickerViewDataSource
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let rows: Int!
        
        if component == 0 {
            rows = self.intergerValues.count
        }
        else {
            rows = self.floatingValues.count
        }
        
        return rows
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    // MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title: NSAttributedString?
        
        if component == 0 {
            title = NSAttributedString(string: "\(self.intergerValues[row])")
        }
        else {
            title = NSAttributedString(string: row == 0 ? ".0" : ".5")
        }
        
        return title
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        var width: CGFloat!
        
        if component == 0 {
            width = pickerView.frame.width / 3
        }
        else {
            width = pickerView.frame.width / 6
        }
        
        return width
    }
    
    // MARK: -Class Properties and Methods
    class var reuseId: String {
        return "TaxValueCell"
    }
}
