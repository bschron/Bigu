//
//  DefaultTaxCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/30/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class DefaultTaxCell: TaxCell {
    // MARK: - Properties
    // MARK: - Outlets
    @IBOutlet weak var taxValueButton: UIButton?
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateTaxUI()
        let loadedValue = self.load() as? Float
        TaxCell.taxValue = loadedValue != nil ? loadedValue! : 0
        updateTaxValueButtonText()
    }
    
    internal func updateTaxValueButtonText() {
        if TaxCell.currentState == .Default {
            self.taxValueButton!.setTitle("\(TaxCell.taxValue)", forState: UIControlState.allZeros)
        }
    }
    
    // MARK: - Protocols
    override func updateTaxUI() {
        updateTaxValueButtonText()
    }
    
    // MARK: - Actions
    @IBAction func increaseButtonPressed(sender: AnyObject) {
        TaxCell.taxValue++
        updateTaxUI()
    }
    @IBAction func halfIncrease(sender: AnyObject) {
        TaxCell.taxValue += 0.5
        updateTaxUI()
    }
    @IBAction func decreaseButtonPressed(sender: AnyObject) {
        TaxCell.taxValue--
        updateTaxUI()
    }
    @IBAction func halfDecrease(sender: AnyObject) {
        TaxCell.taxValue -= 0.5
        updateTaxUI()
    }
    @IBAction func taxValueButtonPressed(sender: AnyObject) {
        if TaxCell.lastStateCell != nil {
            TaxCell.lastStateCell!.updateTaxUI()
        }
        
        self.registerAsLastCell()
        
        TaxCell.currentState = .TaxPicker
        self.tableView?.reloadData()
    }
}