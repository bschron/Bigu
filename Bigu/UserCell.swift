//
//  UserCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/3/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    // MARK: - Properties
    var configured: Bool = false
    var user: User! {
        didSet {
            if user != nil {
                self.configured = true
            }
            self.updateUserInfo()
        }
    }
    var swipeGesture: UISwipeGestureRecognizer!
    var viewController: UIViewController!
    var userIndex: Int = 0 {
        didSet {
            self.user = User.usersList.list[self.userIndex]
        }
    }
    private var originalColor: UIColor?
    
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    // MARK: - Methods
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipes:")
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer){
        if sender.direction == .Right{
            let duration = 0.25
            let delay = 0.0 // delay will be 0.0 seconds (e.g. nothing)
            let options = UIViewAnimationOptions.CurveEaseInOut
            let width = self.frame.size.width
            
            UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
                self.backgroundColor = UIColor(red: CGFloat(0.2), green: CGFloat(0.59607843), blue: CGFloat(0.85882353), alpha: CGFloat(1))
                self.center.x += width
                self.frame.size.width = CGFloat(0)
                }, completion: { finished in
                    
                    UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
                        self.backgroundColor = UIColor.whiteColor()
                        self.frame.size.width = width
                        self.center.x -= width
                        }, completion: { finished in
                            User.usersList.list[self.userIndex].resetBalance()
                    })
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateUserInfo()
        // swipe gesture
        self.swipeGesture.direction = .Right
        self.swipeGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(self.swipeGesture)
        // user image view
        let userImageViewWidth = self.userImageView.frame.width
        self.userImageView.layer.cornerRadius = userImageViewWidth / 2
        self.userImageView.layer.masksToBounds = true
        
        self.originalColor = self.backgroundColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateUserInfo() {
        if configured {
            let user = User.usersList.list[self.userIndex]
            self.nameLabel.text = user.nickName != "" ? user.nickName! : user.name
            self.fullnameLabel.text = user.fullName
            self.userImageView.image = user.userImage
        }
    }
    
    // MARK: Actions
    @IBAction func debitButtonPressed(sender: AnyObject) {
        let currentTaxValue = TaxCell.taxValue
        User.usersList.list[self.userIndex].debitValue(currentTaxValue)
        
        let duration = 0.25
        let delay = 0.0 // delay will be 0.0 seconds (e.g. nothing)
        let options = UIViewAnimationOptions.CurveEaseInOut
        let width = self.frame.size.width
        
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
            self.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.5)
            self.center.x += width
            self.frame.size.width = CGFloat(0)
            }, completion: { finished in
                
                UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
                    self.backgroundColor = UIColor.whiteColor()
                    self.frame.size.width = width
                    self.center.x -= width
                    }, completion: { finished in
                        // any code entered here will be applied
                        // once the animation has completed
                })
        })
    }
    
    // MARK: - Class Methods and Properties
    class var userCellReuseId: String {
        return "userCellReuseId"
    }
}
