//
//  UserDetailViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UserHandlingDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: -Properties
    var userIndex: Int = 0 {
        didSet {
            self.reloadUsersData()
        }
    }
    var billSlider: Bool = false
    
    // MARK: Outlets
    private weak var mainCell: UserDetailMainTableViewCell!
    weak var billSliderCell: UserDetailBillSliderTableViewCell?
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.displayPhotoLibraryPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayPhotoLibraryPicker () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        
        self.presentViewController(imagePicker, animated: true,
            completion: nil)
    }
    
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: Actions

    // MARK: - Protocols
    // MARK: UserHandlingDelegate
    func reloadUsersData() {
        let user = User.usersList.list[userIndex]
        self.title = user.nickName != nil ? user.nickName! : user.name
    }
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: Int = 0
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 && row == 0 {
            height = 100
        }
        else {
            height = 50
        }
        
        return CGFloat(height)
    }
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailViewController.mainCellIdentifier, forIndexPath: indexPath) as! UserDetailMainTableViewCell
                newCell.userIndex = self.userIndex
                newCell.viewController = self
                
                mainCell = newCell
                
                cell = newCell
            }
            else if row == 1 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailViewController.billSliderCellIdentifier, forIndexPath: indexPath) as! UserDetailBillSliderTableViewCell
                
                newCell.userIndex = self.userIndex
                newCell.mainCell = mainCell
                self.billSliderCell = newCell
                
                cell = newCell
            }
        }
        else {
            if row == 0 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailViewController.firstNameCellIdentifier, forIndexPath: indexPath) as! UserDetailFirstNameTableViewCell
                
                newCell.userIndex = self.userIndex
                newCell.userDetailViewController = self
                
                cell = newCell
            }
            else if row == 1 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailViewController.lastnameCellIdentifier, forIndexPath: indexPath) as! UserDetailLastNameTableViewCell
                
                newCell.userIndex = self.userIndex
                newCell.userDetailViewController = self
                
                cell = newCell
            }
            else if row == 2 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailViewController.nicknameCellIdentifier, forIndexPath: indexPath) as! UserDetailNickNameTableViewCell
                
                newCell.userIndex = self.userIndex
                newCell.userDetailViewController = self
                
                cell = newCell
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        if section == 0 {
            rows = billSlider ? 2 : 1
        }
        else if section == 1 {
            rows = 3
        }
        else if section == 2 {
            rows = 0
        }
        
        return rows
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: Int = 0
        
        if section == 0 {
            height = 0
        }
        else if section == 1 {
            height = 50
        }
        else if section == 2 {
            height = Int(self.tableView.frame.height)
            self.tableView.scrollEnabled = false
        }
        
        return CGFloat(height)
    }
    // MARK: UIImagePickekControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        User.usersList.list[userIndex].userImage = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.reloadUsersData()
        self.mainCell.reloadUsersData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Class Properties
    class var mainCellIdentifier: String {
        return "UserDetailMainCellIdentifier"
    }
    class var firstNameCellIdentifier: String {
        return "UserDetailFirstNameCellIdentifier"
    }
    class var lastnameCellIdentifier: String {
        return "UserDetailLastNameIdentifier"
    }
    class var nicknameCellIdentifier: String {
        return "UserDetailNickNameIdentifier"
    }
    class var billSliderCellIdentifier: String {
        return "UserDetailTaxSliderCellIdentifier"
    }
}