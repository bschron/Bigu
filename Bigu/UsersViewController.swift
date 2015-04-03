//
//  UsersViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 3/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDataSource {

    // MARK: - Variables
    
    //MARK: Outlets
    @IBOutlet weak var upperTableView: UITableView!
    @IBOutlet weak var usersTableView: UITableView!
    
    // MARK: - Functions
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
        usersTableView.registerNib(userCellNib, forCellReuseIdentifier: UserCell.userCellReuseId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number: Int = 0
        
        if tableView === upperTableView {
            number = 1
        }
        else if tableView == self.usersTableView {
            number = User.usersTable.count
        }
        return number
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView === self.upperTableView {
            let cell = upperTableView.dequeueReusableCellWithIdentifier(TaxCell.currentState.rawValue, forIndexPath: indexPath) as TaxCell
            // configure cell
            cell.tableView = self.upperTableView
            
            return cell
        }
        else if tableView === self.usersTableView {
            let cell = usersTableView.dequeueReusableCellWithIdentifier(UserCell.userCellReuseId, forIndexPath: indexPath) as UserCell
            let users = User.usersTable
            cell.user = users[indexPath.row]
            
            return cell
        }
        return UITableViewCell()
    }
}
