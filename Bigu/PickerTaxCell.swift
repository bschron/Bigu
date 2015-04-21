//
//  PickerTaxCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/31/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class PickerTaxCell: TaxCell, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Properties
    private var integerValues: [Int] = []
    private var floatingPointValues: [Float] = []
    
    // MARK: - Outlets
    @IBOutlet weak var taxPickerView: UIPickerView?
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setPickerValues()
        self.updateTaxUI()
    }
    
    private func setPickerValues() {
        if TaxCell.currentState != TaxCellState.TaxPicker {
            return
        }
        
        /* instantiate Picker's interger and floatingPoint values */
        if self.integerValues.count == 0 {
            self.integerValues = []
            var maxValue:Int = Int(TaxCell.maximumTaxValue)
            for var i: Int = 0; i <= maxValue; i++ {
                self.integerValues += [i]
            }
        }
        if self.floatingPointValues.count == 0 {
            self.floatingPointValues = [0, 0.5]
        }
    }
    
    private func updatePickerValues() {
        if TaxCell.currentState != .TaxPicker {
            self.integerValues = []
            self.floatingPointValues = []
        }
        else {
            if self.integerValues.count <= 0 || self.floatingPointValues.count <= 0 {
                setPickerValues()
            }
        }
    }
    
    // MARK: - Protocols
    // MARK: Picker Delegate
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        self.updatePickerValues()
        var stringValue: NSAttributedString?
        let color = UIColor.whiteColor()
        
        if component == 0 {
            stringValue = NSAttributedString(string: "\(integerValues[row])", attributes: [NSForegroundColorAttributeName : color])
        }
        else if component == 1 {
            let intValue: Int = Int(self.floatingPointValues[row] * 100)
            stringValue = NSAttributedString(string: ".\(intValue)", attributes: [NSForegroundColorAttributeName : color])
        }
        
        return stringValue
    }
    
    // MARK: Picker Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        self.updatePickerValues()
        return component == 0 ? self.integerValues.count : self.floatingPointValues.count
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let pickerWidth = pickerView.bounds.size.width
        return component == 0 ? (2 * pickerWidth) / 3 : pickerWidth / 3
    }
    // MARK: UpdateTaxCellProtocol
    override func updateTaxUI() {
        let taxValue: Float = TaxCell.taxValue
        let intValue: Int = Int(taxValue)
        let floatValue: Float = taxValue - Float(intValue)
        let floatingValueRow = floatValue == 0 ? 0 : 1
        
        taxPickerView?.selectRow(intValue, inComponent: 0, animated: true)
        taxPickerView?.selectRow(floatingValueRow, inComponent: 1, animated: true)
        return
    }
    
    // MARK: - Actions
    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        let intRow = self.taxPickerView!.selectedRowInComponent(0)
        let floatRow = self.taxPickerView!.selectedRowInComponent(1)
        let intValueAsFloat: Float = Float(self.integerValues[intRow])
        let floatValue: Float = self.floatingPointValues[floatRow]
        let totalValue = intValueAsFloat + floatValue
        TaxCell.taxValue = totalValue
        
        TaxCell.currentState = TaxCellState.Default
        
        if TaxCell.lastStateCell != nil{
            let defaultCell = TaxCell.lastStateCell! as TaxHandlingDelegate
            defaultCell.updateTaxUI()
        }
        registerAsLastCell()
        
        self.tableView!.reloadData()
    }

}
