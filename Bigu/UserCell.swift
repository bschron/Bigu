//
//  UserCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/3/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation
import UIKit
import User
import RGBColor
import FakeSeparator
import UserList
import SwipeOptionsTableViewCell

internal class UserCell: SwipeOptionsTableViewCell {

    // MARK: - Properties
    internal var configured: Bool = false
    internal var user: User! {
        didSet {
            if user != nil {
                self.configured = true
            }
            self.updateUserInfo()
        }
    }
    private var userImageOriginalPosition: (CGFloat, CGFloat) = (CGFloat(0), CGFloat(0))
    private var userImagePanGestureIsActive: Bool = false
    private var invisibleUserImageViewCover: UIView!
    internal var viewController: UIViewController!
    
    
    //MARK: Outlets
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var fullnameLabel: UILabel!
    @IBOutlet weak private var userImageView: UIImageView!
    private var separator: UIView!
    
    // MARK: - Methods
    
    required internal init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let button = SwipeOptionsButtonItem(frame: SwipeOptionsButtonItem.frame(forCell: self))
        button.action = self.debitButtonPressed
        button.setTitle("cash in", forState: UIControlState.allZeros)
        //105 170 129
        button.backgroundColor = RGBColor(r: 105, g: 170, b: 129, alpha: 1)
        
        self.insertLeftButton(button)
    }
    
    override internal func awakeFromNib() {
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
        self.userImageOriginalPosition = (self.userImageView.center.x, self.userImageView.center.y)
        self.insertSubview(self.invisibleUserImageViewCover, aboveSubview: self.userImageView)
        
        // set background color
        self.contentView.backgroundColor = RGBColor.whiteColor()
        self.separator = FakeSeparator(forView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separator.layoutIfNeeded()
    }

    override internal func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateUserInfo() {
        if configured {
            let user = self.user
            self.nameLabel.text = user.nickName != "" ? user.nickName : user.name
            self.fullnameLabel.text = user.fullName
            self.userImageView.image = user.userImage
        }
    }
    
    internal func moveUserImage(sender: UIPanGestureRecognizer) {
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
                            //UserList.sharedUserList.list.getElementAtIndex(self.userIndex)!.payBill()
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
    @IBAction private func debitButtonPressed(sender: AnyObject) {
        self.user.charge()
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
    class internal var userCellReuseId: String {
        return "userCellReuseId"
    }
}
