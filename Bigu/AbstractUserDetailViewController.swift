//
//  AbstractUserDetailViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/22/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Models
import RGBColor
import RideTableViewCell

public class AbstractUserDetailViewController: UIViewController, UserHandlingDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: -Properties
    public var user: AbstractUser! {
        didSet {
            self.reloadUsersData()
        }
    }
    
    // MARK: Outlets
    internal(set) weak var mainCell: AbstractUserDetailMainTableViewCell!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.displayPhotoLibraryPicker()
        
        self.tableView.registerNib(UINib(nibName: "RideTableViewCell", bundle: NSBundle(identifier: "IC.RideTableViewCell")), forCellReuseIdentifier: RideTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "UserDetailFirstNameTableViewCell", bundle: NSBundle(identifier: "IC.UserDetailViewController")), forCellReuseIdentifier: UserDetailFirstNameTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "UserDetailLastNameTableViewCell", bundle: NSBundle(identifier: "IC.UserDetailViewController")), forCellReuseIdentifier: UserDetailLastNameTableViewCell.reuseId)
        self.tableView.registerNib(UINib(nibName: "UserDetailNickNameTableViewCell", bundle: NSBundle(identifier: "IC.UserDetailViewController")), forCellReuseIdentifier: UserDetailNickNameTableViewCell.reuseId)
        
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.separatorStyle = .None
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    internal func displayPhotoLibraryPicker () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        
        self.presentViewController(imagePicker, animated: true,
            completion: nil)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.reloadUsersData()
    }
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: Actions
    
    // MARK: - Protocols
    // MARK: UserHandlingDelegate
    public func reloadUsersData() {
        self.title = self.user.nickName != "" ? self.user.nickName : self.user.name
    }
    // MARK: UITableViewDelegate
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            
            let color: UIColor!
            
            if indexPath.row % 2 != 0 {
                color = RGBColor(r: 122, g: 183, b: 147, alpha: 0.1)
            }
            else {
                color = UIColor.whiteColor()
            }
            
            cell.backgroundColor = color
        }
    }
    
    // MARK: UITableViewDataSource
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell! //not implemented
        return UITableViewCell()
    }
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        //not implemented
        return rows
    }
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        
        if section == 2 {
            title = "Ride History"
        }
        
        return title
    }
    // MARK: UIImagePickekControllerDelegate
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.user.userImage = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.reloadUsersData()
        self.mainCell.reloadUsersData()
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
