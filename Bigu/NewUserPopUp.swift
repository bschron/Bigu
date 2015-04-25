//
//  NewUserPopUp.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/3/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Models

internal class NewUserPopUp: UIView {

    // MARK: - Properties
    private var view: UIView!
    private(set) var blurView: UIVisualEffectView?
    private var usersHandler: UserHandlingDelegate?
    private var viewController: UsersViewController?
    private var isBeingTerminated: Bool = false
    
    @IBOutlet weak private var box: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var header: UIView!
    
    
    internal var nibName: String {
        return "NewUserPopUp"
    }
    
    // MARK: - Methods
    
    private func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        box.layer.cornerRadius = 20
        addButton.layer.cornerRadius = 20
        cancelButton.layer.cornerRadius = 20
        header.layer.cornerRadius = 20
        box.layer.shadowOpacity = 0.8
        box.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    internal init(frame: CGRect, aViewController vc: UsersViewController, aHandler handler: UserHandlingDelegate?) {
        super.init(frame: frame)
        self.xibSetup()
        self.viewController = vc
        self.usersHandler = handler
    }
    
    required internal init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    internal func terminate() {
        if !self.isBeingTerminated {
            self.isBeingTerminated = true
            UIView.animateWithDuration(0.25
                , delay: 0.0, options: UIViewAnimationOptions.LayoutSubviews | UIViewAnimationOptions.CurveLinear, animations: {
                    self.blurView?.alpha = CGFloat(0)
                    self.alpha = CGFloat(0)
                }, completion: { result in
                    self.blurView?.removeFromSuperview()
                    self.removeFromSuperview()
                    self.viewController?.freePopUp()
            })
        }
    }
    
    internal func transitionToSize(size: CGSize) {
        self.frame.size = size
        if self.blurView != nil {
            self.blurView!.frame.size = size
        }
    }
    
    internal func tryToAddUserWithProvidedInfo() -> Bool {
        let result: Bool!
        
        if nameTextField.text != "" {
            let newUser = User(name: nameTextField.text, surName: surnameTextField.text, nickName: nicknameTextField.text, handler: nil)
            newUser.synchronize()
            self.terminate()
            
            if let handler = usersHandler {
                handler.reloadUsersData()
            }
            result = true
        }
        else {
            self.title.text = "Name Required"
            result = false
        }
        
        return result
    }
    
    // MARK: Actions
    @IBAction private func addButtonPressed(sender: AnyObject) {
        self.tryToAddUserWithProvidedInfo()
    }
    @IBAction private func cancelButtonPressed(sender: AnyObject) {
        self.terminate()
    }
    @IBAction private func closeKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    @IBAction private func tappedOutside(sender: AnyObject) {
        self.terminate()
    }
    
    // MARK: - Class Methods
    class internal func addPopUpToView (aViewController vc: UsersViewController, usersHandler handler: UserHandlingDelegate?) -> UIView {

        let aView = vc.view
        let frame = aView.frame
        let pop = NewUserPopUp(frame: frame, aViewController: vc, aHandler: handler)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = frame
        blurView.center = aView.center
        aView.addSubview(blurView)
        
        aView.addSubview(pop)
        
        pop.blurView = blurView
        return pop
    }
}
