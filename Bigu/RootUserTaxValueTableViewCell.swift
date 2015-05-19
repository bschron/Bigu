//
//  RootUserTaxValueTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/23/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Foundation
import RGBColor
import User
import RootUser
import Billing

internal class RootUserTaxValueTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: -Properties
    private var _intValues: Array<Int>?
    internal var intergerValues: Array<Int> {
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
    internal var floatingValues: [Float] {
        get {
            var array = Array<Float>()
            for var i: Float = 0; i < 100; i += 5 {
                array += [i / 100]
            }
            return array
        }
    }
    internal var sourceTaxValue: Float {
        return Bill.taxValue
    }
    internal var removeFromTableView: (() -> ())?
    
    // MARK: Outlets
    @IBOutlet weak internal var taxValuePickerView: UIPickerView!
    @IBOutlet weak internal var label: UILabel!
    
    // MARK: -Methods
    override internal func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.taxValuePickerView.dataSource = self
        self.taxValuePickerView.delegate = self
        self.backgroundColor = RGBColor(r: 122, g: 183, b: 147, alpha: 1)
    }

    override internal func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func getTaxPickerValue() -> Float {
        let intValueRow = self.taxValuePickerView.selectedRowInComponent(0)
        let intValue = self.intergerValues[intValueRow]
        let floatValueRow = self.taxValuePickerView.selectedRowInComponent(1)
        let floatValue = self.floatingValues[floatValueRow]
        let totalValue = Float(intValue) + floatValue
        return totalValue
    }
    
    internal func setTaxPickerValue() {
        let taxValue: Float = self.sourceTaxValue
        let taxIntValue: Int = Int(taxValue)
        let taxPointValue: Float = taxValue - Float(taxIntValue)
        
        var taxIntValueRow: Int = 0
        for cur in self.intergerValues {
            if cur == taxIntValue
            {
                break
            }
            taxIntValueRow++
        }
        
        var taxPointValueRow: Int = 0
        for cur in self.floatingValues {
            if cur == taxPointValue {
                break
            }
            taxPointValueRow++
        }
        
        self.taxValuePickerView.selectRow(taxIntValueRow, inComponent: 0, animated: true)
        self.taxValuePickerView.selectRow(taxPointValueRow, inComponent: 1, animated: true)
    }
    
    // MARK: Actions
    @IBAction internal func commitNewTaxValue(sender: AnyObject) {
        Bill.taxValue = self.getTaxPickerValue()
        self.removeFromTableView?()
    }
    
    @IBAction internal func cancel() {
        self.removeFromTableView?()
    }
    
    // MARK: -Protocols
    // MARK: UIPickerViewDataSource
    internal func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let rows: Int!
        
        if component == 0 {
            rows = self.intergerValues.count
        }
        else {
            rows = self.floatingValues.count
        }
        
        return rows
    }
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    // MARK: UIPickerViewDelegate
    internal func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title: NSAttributedString?
        
        if component == 0 {
            title = NSAttributedString(string: "\(self.intergerValues[row])")
        }
        else {
            let values = self.floatingValues
            let value = Int(values[row] * 100)
            title = NSAttributedString(string: String(format: ".%.2d", value))
        }
        
        return title
    }
    internal func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
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
    class internal var reuseId: String {
        return "TaxValueCell"
    }
}
