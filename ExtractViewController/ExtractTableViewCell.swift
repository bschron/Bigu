//
//  ExtractTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/25/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Extract
import UserList
import Collection
import User
import FakeSeparator

internal class ExtractTableViewCell: UITableViewCell {
    
    // MARK: -Properties
    internal var extract: Extract? {
        didSet {
            self.loadInfo()
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    
    // MARK: -Methods

    override internal func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.loadInfo()
        self.coinImage.image = UIImage(named: "coin")
    }
    
    private func loadInfo() {
        if let extract = self.extract {
            let resultUsers: OrderedList<User> = UserList.sharedUserList.list.findBy({ $0.id == extract.userId })
            
            var user: User? = resultUsers.getFirstObject()
            if user == nil {
                user = UserList.sharedUserList.erasedUsersList.findBy({ $0.id == extract.userId }).getFirstObject()
            }
            
            var name: String?
            
            if let usr = user {
                if usr.nickName == "" {
                    name = usr.fullName
                }
                else {
                    name = usr.nickName
                }
            }
            else {
                name = "Name"
            }
            let value = extract.value
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = "dd/MM/YY HH:mm"
            
            self.nameLabel.text = name
            self.valueLabel.text = String(format: "$%.2f", value)
            self.dateLabel.text = dateFormater.stringFromDate(extract.date)
            
            self.extract = nil
        }
    }
    
    // MARK: -Class Properties
    class internal var reuseId: String {
        return "ExtractTableViewCellReuseId"
    }
}