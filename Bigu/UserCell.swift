//
//  UserCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/3/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
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
    //private var swipeGesture: UISwipeGestureRecognizer!
    private var userImagePanGesture: UIPanGestureRecognizer!
    private var userImageOriginalPosition: (CGFloat, CGFloat) = (CGFloat(0), CGFloat(0))
    private var userImagePanGestureIsActive: Bool = false
    private var invisibleUserImageViewCover: UIView!
    var viewController: UIViewController!
    var userIndex: Int = 0 {
        didSet {
            self.user = User.usersList.list.getElementAtIndex(self.userIndex)!
        }
    }
    
    
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fakeSeparator: UIView!
    
    // MARK: - Methods
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateUserInfo()
        let userImageViewWidth = self.userImageView.frame.width
        self.userImageView.layer.cornerRadius = userImageViewWidth / 2
        self.userImageView.layer.masksToBounds = true
        
        self.invisibleUserImageViewCover = UIView()
        self.invisibleUserImageViewCover.frame.size.height = self.userImageView.frame.size.height + 2
        self.invisibleUserImageViewCover.frame.size.width = self.userImageView.frame.size.width + 2
        self.invisibleUserImageViewCover.center = self.userImageView.center
        self.invisibleUserImageViewCover.layer.cornerRadius = self.userImageView.layer.cornerRadius
        self.invisibleUserImageViewCover.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(CGFloat(0))
        self.userImagePanGesture = UIPanGestureRecognizer(target: self, action: "moveUserImage:")
        self.userImagePanGesture.minimumNumberOfTouches = 1
        self.userImagePanGesture.maximumNumberOfTouches = 1
        self.invisibleUserImageViewCover.addGestureRecognizer(self.userImagePanGesture)
        self.userImageOriginalPosition = (self.userImageView.center.x, self.userImageView.center.y)
        self.insertSubview(self.invisibleUserImageViewCover, aboveSubview: self.userImageView)
        
        // set background color
        self.backgroundColor = RGBColor.whiteColor()
        self.fakeSeparator.backgroundColor = RGBColor(r: 76, g: 153, b: 107, alpha: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateUserInfo() {
        if configured {
            let user = User.usersList.list.getElementAtIndex(self.userIndex)!
            self.nameLabel.text = user.nickName != "" ? user.nickName : user.name
            self.fullnameLabel.text = user.fullName
            self.userImageView.image = user.userImage
        }
    }
    
    func moveUserImage(sender: UIPanGestureRecognizer) {
        if sender.state != .Ended && sender.state != .Failed {
            self.userImagePanGestureIsActive = true
            let location = sender.locationInView(self)
            self.userImageView.center.x = location.x
        }
        else if sender.state == .Ended {
            let location = sender.locationInView(self)
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                self.userImageView.center.x = self.userImageOriginalPosition.0
                }, completion: {result in
                    let originalColor = self.invisibleUserImageViewCover.backgroundColor!
                    let blurEffect = UIBlurEffect(style: .Light)
                    let blurView = UIVisualEffectView(effect: blurEffect)
                    self.addSubview(blurView)
                    blurView.frame = self.invisibleUserImageViewCover.frame
                    blurView.layer.cornerRadius = self.invisibleUserImageViewCover.layer.cornerRadius
                    blurView.layer.masksToBounds = true
                    blurView.alpha = CGFloat(0)
                    blurView.center = self.invisibleUserImageViewCover.center
                    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    
                        blurView.alpha = CGFloat(0.9)
                        
                        if location.x >= self.frame.width / 2 {
                            let newColor = RGBColor.whiteColor().colorWithAlphaComponent(0.1)
                            self.invisibleUserImageViewCover.backgroundColor = newColor
                            User.usersList.list.getElementAtIndex(self.userIndex)!.payBill()
                        }
                        else {
                            let newColor = UIColor.blackColor().colorWithAlphaComponent(CGFloat(0.75))
                            self.invisibleUserImageViewCover.backgroundColor = newColor
                        }
                        }, completion: {result in
                            UIView.animateWithDuration(0.1, delay: 0.15, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                                self.invisibleUserImageViewCover.backgroundColor = originalColor
                                blurView.alpha = CGFloat(0)
                                }, completion: {result in
                                    blurView.removeFromSuperview()
                            })
                    })
            })
        }
    }
    
    // MARK: Actions
    @IBAction func debitButtonPressed(sender: AnyObject) {
        User.usersList.list.getElementAtIndex(self.userIndex)!.increaseBill()
        //Animation
        let duration = 0.3
        let delay = 0.0 // delay will be 0.0 seconds (e.g. nothing)
        let options = UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseIn
        let width = self.userImageView.frame.width
        let jump = width / 10
        
        let originalImageView = self.userImageView
        let imageViewCopy = UIImageView(image: UIImage(named: "Money"))
        imageViewCopy.frame.size = originalImageView.frame.size
        imageViewCopy.center = originalImageView.center
        imageViewCopy.layer.cornerRadius = originalImageView.layer.cornerRadius
        imageViewCopy.layer.masksToBounds = originalImageView.layer.masksToBounds
        self.insertSubview(imageViewCopy, aboveSubview: originalImageView)
        imageViewCopy.alpha = CGFloat(0)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = originalImageView.frame
        originalImageView.addSubview(blurView)
        blurView.alpha = CGFloat(0)
        
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
            imageViewCopy.alpha = CGFloat(1)
            blurView.alpha = CGFloat(1)
            }, completion: { finished in
                UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
                    imageViewCopy.alpha = CGFloat(0)
                    blurView.alpha = CGFloat(0)
                    }, completion: { finished in
                        imageViewCopy.removeFromSuperview()
                        blurView.removeFromSuperview()
                })
        })
    }
    
    // MARK: - Class Methods and Properties
    class var userCellReuseId: String {
        return "userCellReuseId"
    }
}
