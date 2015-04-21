//
//  RideTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/20/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class RideTableViewCell: UITableViewCell {

    // MARK: -Properties
    var ride: Ride! {
        didSet{
            self.reloadRideData()
        }
    }
    
    // MARK: -Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: -Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        self.userImage.layer.masksToBounds = true
        self.userImage.backgroundColor = UIColor.redColor().colorWithAlphaComponent(CGFloat(0.5))
    }
    
    func reloadRideData() {
        
        let findingparameter: (User) -> Bool = { $0.id == self.ride.userId }
        
        var user = User.usersList.list.findBy(findingparameter)
        
        if user.getFirstObject() == nil {
            let erasedUsers = User.usersList.erasedUsersList.findBy(findingparameter).arrayCopy()
            user.insert(erasedUsers)
        }
        
        if let usr = user.getFirstObject() {
            self.userImage.image = usr.userImage
            self.nameLabel.text = usr.nickName != "" ? usr.nickName : usr.fullName
        }
        else {
            self.userImage.image = UIImage(named: "user")
            self.nameLabel.text = "unkown"
        }
        self.dateLabel.text = shortDate(self.ride.time)
        self.valueLabel.text = "$" + " " + "\(self.ride.value)"
    }

    private func shortDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM HH:mm"
        return dateFormatter.stringFromDate(date)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: -Class Properties and Methods
    class var reuseId: String {
        return "RideCell"
    }
}
