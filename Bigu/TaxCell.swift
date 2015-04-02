//
//  TaxCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/31/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Foundation

class TaxCell: UITableViewCell, TaxHandlingDelegate, DataPersistenceDelegate {

    //MARK: - TADS
    enum TaxCellState: String {
        case TaxPicker = "PickerTaxCell"
        case Default = "DefaultTaxCell"
    }
    
    // MARK: - Properties
    private var _tableView: UITableView?
    internal var tableView: UITableView? {
        get {
            return self._tableView
        }
        set {
            if newValue != nil {
                _tableView = newValue
            }
        }
    }
    
    // MARK: DataManagingDelegate
    private var taxKey: String {
        get {
            return "TaxKey"
        }
    }
    private var dataKey: String {
        get {
            return "TaxValuePersistenceKey"
        }
    }
    var object: AnyObject? {
        get {
            return TaxCell.taxValue
        }
        set {}
    }
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // persistence call
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationWillResignActive:",
            name: UIApplicationWillResignActiveNotification,
            object: app)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func applicationWillResignActive(notification:NSNotification) {
        self.save()
    }
    
    // MARK: - Protocols
    // MARK: TaxHandlingDelegate
    func updateTaxUI() {
        return
    }
    func registerAsLastCell() {
        TaxCell.storedLastStateCell(self)
    }
    
    // MARK: DataManagingDelegate
    func save() -> Bool {
        var data: [String: AnyObject] = [self.taxKey : self.object!]
        let dictionary = data as NSDictionary
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dictionary, forKey: self.dataKey)
        let result = defaults.synchronize()
        
        return result
    }
    func load() -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let storedDictionary = defaults.objectForKey(self.dataKey) as? NSDictionary
        let floatingPointValue = storedDictionary?[self.taxKey] as? Float?
        return floatingPointValue != nil ? floatingPointValue! : nil
    }

    // MARK: - Class Methods
    class private func storedCurrentState (newState: TaxCellState?) -> TaxCellState {
        struct storedState {
            static var currentState: TaxCellState?
        }
        
        if let state = newState {
            storedState.currentState = state
        }
        
        return storedState.currentState != nil ? storedState.currentState! : TaxCellState.Default
    }
    class private func storedTaxValue (newValue: Float?) -> Float {
        struct storedValue {
            static var currentValue: Float?
        }
        
        if newValue != nil {
            storedValue.currentValue = newValue
        }
        
        return (storedValue.currentValue != nil) ? storedValue.currentValue! : 0
    }
    class private func storedLastStateCell(last: TaxCell?) -> TaxCell? {
        struct storedLast {
            static weak var currentLast: TaxCell?
        }
        
        if last != nil {
            storedLast.currentLast = last
        }
        
        return storedLast.currentLast
    }
    class var currentState: TaxCellState {
        get {
            return TaxCell.storedCurrentState(nil)
        }
        set {
            TaxCell.storedCurrentState(newValue)
        }
    }
    class var taxValue: Float {
        get {
            return TaxCell.storedTaxValue(nil)
        }
        set {
            if newValue >= 0 && newValue <= TaxCell.maximumTaxValue {
                TaxCell.storedTaxValue(newValue)
            }
        }
    }
    class var lastStateCell: TaxCell? {
        get {
            return TaxCell.storedLastStateCell(nil)
        }
        set {
            TaxCell.storedLastStateCell(newValue)
        }
    }
    class var maximumTaxValue: Float {
        get {
            return 100.5
        }
    }
}
