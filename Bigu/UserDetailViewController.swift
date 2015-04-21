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
    private(set) weak var mainCell: UserDetailMainTableViewCell!
    weak var billSliderCell: UserDetailBillSliderTableViewCell?
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.displayPhotoLibraryPicker()
        
        self.tableView.registerNib(UINib(nibName: "RideTableViewCell", bundle: nil), forCellReuseIdentifier: RideTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "UserDetailMainTableViewCell", bundle: nil), forCellReuseIdentifier: UserDetailMainTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "UserDetailBillSliderTableViewCell", bundle: nil), forCellReuseIdentifier: UserDetailBillSliderTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "UserDetailFirstNameTableViewCell", bundle: nil), forCellReuseIdentifier: UserDetailFirstNameTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "UserDetailLastNameTableViewCell", bundle: nil), forCellReuseIdentifier: UserDetailLastNameTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "UserDetailNickNameTableViewCell", bundle: nil), forCellReuseIdentifier: UserDetailNickNameTableViewCell.reuseId)
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
        let user = User.usersList.list.getElementAtIndex(self.userIndex)!
        self.title = user.nickName != "" ? user.nickName : user.name
    }
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: Int = 0
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 && row == 0 {
            height = 100
        }
        else if section == 2 {
            height = 80
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
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailMainTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailMainTableViewCell
                newCell.userIndex = self.userIndex
                newCell.viewController = self
                
                mainCell = newCell
                
                cell = newCell
            }
            else if row == 1 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailBillSliderTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailBillSliderTableViewCell
                
                newCell.userIndex = self.userIndex
                newCell.mainCell = mainCell
                self.billSliderCell = newCell
                newCell.viewController = self
                
                cell = newCell
            }
        }
        else if section == 1 {
            if row == 0 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailFirstNameTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailFirstNameTableViewCell
                
                newCell.userIndex = self.userIndex
                newCell.userDetailViewController = self
                
                cell = newCell
            }
            else if row == 1 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailLastNameTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailLastNameTableViewCell
                
                newCell.userIndex = self.userIndex
                newCell.userDetailViewController = self
                
                cell = newCell
            }
            else if row == 2 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailNickNameTableViewCell.reuseId, forIndexPath: indexPath) as! UserDetailNickNameTableViewCell
                
                newCell.userIndex = self.userIndex
                newCell.userDetailViewController = self
                
                cell = newCell
            }
        }
        else if section == 2 {
            let newCell = tableView.dequeueReusableCellWithIdentifier(RideTableViewCell.reuseId, forIndexPath: indexPath) as! RideTableViewCell
            
            let user = User.usersList.list.getElementAtIndex(self.userIndex)!
            let rideHistory = user.rideHistory!
            let ride = rideHistory.list.getElementAtIndex(row)
            
            newCell.ride = ride
            
            cell = newCell
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
            let user = User.usersList.list.getElementAtIndex(self.userIndex)!
            let rideHistory = user.rideHistory!
            rows = rideHistory.count
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
            height = 30
        }
        
        return CGFloat(height)
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        
        if section == 2 {
            title = "Ride History"
        }
        
        return title
    }
    // MARK: UIImagePickekControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        User.usersList.list.getElementAtIndex(self.userIndex)!.userImage = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.reloadUsersData()
        self.mainCell.reloadUsersData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}