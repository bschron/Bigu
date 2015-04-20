//
//  UsersViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserHandlingDelegate {

    // MARK: - Proprierties
    private weak var popUp: NewUserPopUp?
    
    //MARK: Outlets
    @IBOutlet weak var upperTableView: UITableView!
    @IBOutlet weak var usersTableView: UITableView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* register tax cells nibs*/
        let defaultTaxCellNib = UINib(nibName: "TaxCell", bundle: nil)
        let pickerTaxCellNib = UINib(nibName: "PickerTaxCell", bundle: nil)
        upperTableView.registerNib(defaultTaxCellNib, forCellReuseIdentifier: TaxCell.TaxCellState.Default.rawValue)
        upperTableView.registerNib(pickerTaxCellNib, forCellReuseIdentifier: TaxCell.TaxCellState.TaxPicker.rawValue)
        /* register user cells nibs */
        let userCellNib = UINib(nibName: "UserCell", bundle: nil)
        self.usersTableView.registerNib(userCellNib, forCellReuseIdentifier: UserCell.userCellReuseId)
        
        // persistence call
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationWillResignActive:",
            name: UIApplicationWillResignActiveNotification,
            object: app)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUsersData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        UserList.freeSingleton(nil)
    }
    
    // MARK: Actions
    @IBAction func addUserButtonPressed(sender: AnyObject) {
        self.popUp = NewUserPopUp.addPopUpToView(self.view, usersHandler: self) as? NewUserPopUp
        self.popUp!.alpha = CGFloat(0)
        self.popUp!.blurView?.alpha = CGFloat(0)
        UIView.animateWithDuration(0.25
            , delay: 0.0, options: UIViewAnimationOptions.LayoutSubviews | UIViewAnimationOptions.CurveLinear, animations: {
                self.popUp!.alpha = CGFloat(1)
                self.popUp!.blurView?.alpha = CGFloat(1)
            }, completion: {result in})
    }
    
    func applicationWillResignActive(notification:NSNotification) {
        /*let userManager = UserPersistenceManager()
        let futureResult = userManager.save(ImmediateExecutionContext)
        futureResult.onFailure(context: ImmediateExecutionContext, callback: { error in
            userManager.save(ImmediateExecutionContext)
        })*/
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if let pop = self.popUp {
            pop.transitionToSize(size)
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == UsersViewController.userDetailSegueIdentifier {
            let vc = segue.destinationViewController as! UserDetailViewController
            let senderCell = sender as! UserCell
            let userName = senderCell.user.nickName != "" ? senderCell.user.nickName : senderCell.user.name
            
            vc.title = userName
            vc.userIndex = senderCell.userIndex
        }
    }
    
    // MARK: -Protocols
    
    // MARK: TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number: Int = 0
        
        if tableView === upperTableView {
            number = 1
        }
        else if tableView == self.usersTableView {
            number = UserList.sharedUserList.list.count
        }
        return number
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView === self.upperTableView {
            let cell = upperTableView.dequeueReusableCellWithIdentifier(TaxCell.currentState.rawValue, forIndexPath: indexPath) as! TaxCell
            // configure cell
            cell.tableView = self.upperTableView
            
            return cell
        }
        else if tableView === self.usersTableView {
            let cell = usersTableView.dequeueReusableCellWithIdentifier(UserCell.userCellReuseId, forIndexPath: indexPath) as! UserCell
            cell.user = UserList.sharedUserList.list.getElementAtIndex(indexPath.row)!
            cell.userIndex = indexPath.row
            cell.viewController = self
            
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: TableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var height: CGFloat!
        
        if tableView === self.usersTableView {
            height = CGFloat(80)
        }
        else if tableView === self.upperTableView {
            height = CGFloat(100)
        }
        
        return height
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var result: Bool!
        
        if tableView === self.usersTableView {
            result = true
        }
        else {
            result = false
        }
        
        return result
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView === self.usersTableView {
            if editingStyle == .Delete {
                User.removeUserAtRow(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var result: Bool!
        
        if tableView === upperTableView {
            result = false
        }
        else {
            result = true
        }
        
        return result
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        let cell = self.usersTableView.cellForRowAtIndexPath(indexPath)
        
        self.performSegueWithIdentifier(UsersViewController.userDetailSegueIdentifier, sender: cell)
    }
    
    // MARK: UserHandlingDelegate
    func reloadUsersData() {
        self.usersTableView.reloadData()
    }
    
    // MARK: - Class Properties
    class var userDetailSegueIdentifier: String {
        return "UserDetailSegue"
    }
}
