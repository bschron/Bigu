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
        let DefaultTaxCellNib = UINib(nibName: "TaxCell", bundle: nil)
        let PickerTaxCellNib = UINib(nibName: "PickerTaxCell", bundle: nil)
        upperTableView.registerNib(DefaultTaxCellNib, forCellReuseIdentifier: TaxCell.TaxCellState.Default.rawValue)
        upperTableView.registerNib(PickerTaxCellNib, forCellReuseIdentifier: TaxCell.TaxCellState.TaxPicker.rawValue)
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
        
        if tableView == self.upperTableView {
            number =  1
        }
        else {
            number =  0
        }
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = upperTableView.dequeueReusableCellWithIdentifier(TaxCell.currentState.rawValue, forIndexPath: indexPath) as TaxCell
        // configure cell
        cell.tableView = self.upperTableView
        
        return cell
    }
}
