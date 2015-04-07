//
//  UserDetailViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/6/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UserHandlingDelegate, UITableViewDataSource, UITableViewDelegate {

    // MARK: -Properties
    var userIndex: Int = 0 {
        didSet {
            self.reloadUsersData()
        }
    }
    private var billSlider: Bool = false
    
    // MARK: Outlets
    private weak var mainCell: UserDetailMainTableViewCell!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if indexPath.row == 0 {
            height = 100
        }
        else {
            height = 50
        }
        
        return CGFloat(height)
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row == 0 {
            let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailViewController.mainCellIdentifier, forIndexPath: indexPath) as UserDetailMainTableViewCell
            newCell.userIndex = self.userIndex
            
            mainCell = newCell
            cell = newCell
        }
        else {
            let increment: Int = billSlider ? 0 : 1
            let row = indexPath.row + increment
            
            if row == 1 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailViewController.billSliderCellIdentifier, forIndexPath: indexPath) as UserDetailBillSliderTableViewCell
                newCell.userIndex = self.userIndex
                newCell.mainCell = mainCell
                
                cell = newCell
            }
            else if row == 2 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailViewController.firstNameCellIdentifier, forIndexPath: indexPath) as UserDetailFirstNameTableViewCell
                newCell.userIndex = self.userIndex
                newCell.userDetailViewController = self
                
                cell = newCell
            }
            else if row == 3 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailViewController.lastnameCellIdentifier, forIndexPath: indexPath) as UserDetailLastNameTableViewCell
                newCell.userIndex = self.userIndex
                newCell.userDetailViewController = self
                
                cell = newCell
            }
            else if row == 4 {
                let newCell = tableView.dequeueReusableCellWithIdentifier(UserDetailViewController.nicknameCellIdentifier, forIndexPath: indexPath) as UserDetailNickNameTableViewCell
                
                newCell.userIndex = self.userIndex
                newCell.userDetailViewController = self
                
                cell = newCell
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.billSlider ? 5 : 4
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
