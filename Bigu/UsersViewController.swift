//
//  UsersViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Models
import UserDetailViewController

public class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserHandlingDelegate {

    // MARK: - Proprierties
    private weak var popUp: NewUserPopUp?
    
    //MARK: Outlets
    @IBOutlet weak var usersTableView: UITableView!
    
    // MARK: - Methods
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.usersTableView.backgroundColor = UIColor.whiteColor()
        self.usersTableView.separatorStyle = .None
        
        /* register user cells nibs */
        let userCellNib = UINib(nibName: "UserCell", bundle: NSBundle(identifier: "IC.UsersViewController"))
        self.usersTableView.registerNib(userCellNib, forCellReuseIdentifier: UserCell.userCellReuseId)
        
        // persistence call
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationWillResignActive:",
            name: UIApplicationWillResignActiveNotification,
            object: app)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUsersData()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        UserList.freeSingleton(nil)
    }
    
    func freePopUp() {
        if self.popUp != nil {
            self.popUp!.terminate()
            self.popUp = nil
        }
    }
    
    // MARK: Actions
    @IBAction func addUserButtonPressed(sender: AnyObject) {
        
        if self.popUp != nil {
            self.popUp!.tryToAddUserWithProvidedInfo()
            self.freePopUp()
            return
        }
        
        self.popUp = NewUserPopUp.addPopUpToView(aViewController: self, usersHandler: self) as? NewUserPopUp
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
    
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if let pop = self.popUp {
            pop.transitionToSize(size)
        }
    }
    
    // MARK: Navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == UsersViewController.userDetailSegueIdentifier {
            let vc = segue.destinationViewController as! UserDetailViewController
            let senderCell = sender as! UserCell
            let userName = senderCell.user.nickName != "" ? senderCell.user.nickName : senderCell.user.name
            
            vc.title = userName
            vc.user = User.usersList.list.getElementAtIndex(senderCell.userIndex)
        }
    }
    
    // MARK: -Protocols
    
    // MARK: TableViewDataSource
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserList.sharedUserList.list.count
    }
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = usersTableView.dequeueReusableCellWithIdentifier(UserCell.userCellReuseId, forIndexPath: indexPath) as! UserCell
        cell.user = UserList.sharedUserList.list.getElementAtIndex(indexPath.row)!
        cell.userIndex = indexPath.row
        cell.viewController = self
        
        return cell
    }
    
    // MARK: TableViewDelegate
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(80)
    }
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var result: Bool!
        
        if tableView === self.usersTableView {
            result = true
        }
        else {
            result = false
        }
        
        return result
    }
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView === self.usersTableView {
            if editingStyle == .Delete {
                User.removeUserAtRow(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        let cell = self.usersTableView.cellForRowAtIndexPath(indexPath)
        
        self.performSegueWithIdentifier(UsersViewController.userDetailSegueIdentifier, sender: cell)
    }
    
    // MARK: UserHandlingDelegate
    public func reloadUsersData() {
        self.usersTableView.reloadData()
    }
    
    // MARK: - Class Properties
    class var userDetailSegueIdentifier: String {
        return "UserDetailSegue"
    }
}
