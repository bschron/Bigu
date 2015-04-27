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
    override internal var sourceTaxValue: Float {
        return 0.0
    }
    
    // MARK: -Methods
    override internal func awakeFromNib() {
        super.awakeFromNib()
        self.label.text = "Paying Value"
    }
    
    // MARK: -Class Properties and Methods
    override class internal var reuseId: String {
        return "UserDetailTaxValueCell"
    }
}