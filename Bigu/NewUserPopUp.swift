//
//  NewUserPopUp.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/3/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class NewUserPopUp: UIView {

    // MARK: - Properties
    var view: UIView!
    var usersHandler: UserHandlingDelegate?
    
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
    
    var nibName: String {
        return "NewUserPopUp"
    }
    
    // MARK: - Methods
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
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
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func terminate() {
        self.removeFromSuperview()
    }
    
    // MARK: Actions
    @IBAction func addButtonPressed(sender: AnyObject) {
        if nameTextField.text != "" {
            User(name: nameTextField.text, surName: surnameTextField.text, nickName: nicknameTextField.text, handler: nil)
            self.terminate()
            
            if let handler = usersHandler {
                handler.reloadUsersData()
            }
        }
        else {
            self.title.text = "Name Required"
        }
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.terminate()
    }
    @IBAction func closeKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    @IBAction func tappedOutside(sender: AnyObject) {
        self.terminate()
    }
    
    // MARK: - Class Methods
    class func addPopUpToView (aView: UIView, usersHandler handler: UserHandlingDelegate?) {
        let frame = aView.frame
        let pop = NewUserPopUp(frame: frame)
        pop.usersHandler = handler
        aView.addSubview(pop)
    }
}
