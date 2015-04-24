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
        self.userImage.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(CGFloat(0))
        self.backgroundColor = RideTableViewCell.curColor
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
    private enum Color {
        case first
        case second
        
        mutating func toggle() {
            if self == .first {
                self = .second
            }
            else {
                self = .first
            }
        }
    }
    class private var curColor: UIColor {
        struct wrap {
            static var cur: Color = Color.first
        }
        
        wrap.cur.toggle()

        if wrap.cur == .first {
            return RGBColor(r: 122, g: 183, b: 147, alpha: 0.1)
        }
        else {
            return UIColor.whiteColor()
        }
    }
}
