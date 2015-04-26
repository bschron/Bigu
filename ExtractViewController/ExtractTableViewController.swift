//
//  ExtractTableViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/25/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Collection
import Extract
import RGBColor

public class ExtractTableViewController: UITableViewController {

    // MARK: -Properties
    public var extractList: OrderedList<Extract>? {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    // MARK: -Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = NSBundle(identifier: "IC.ExtractViewController")
        let extractCellNib = UINib(nibName: "ExtractTableViewCell", bundle: bundle)
        self.tableView.registerNib(extractCellNib, forCellReuseIdentifier: ExtractTableViewCell.reuseId)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: -Protocols
    // MARK: Table view data source

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.extractList != nil ? self.extractList!.count : 0
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ExtractTableViewCell.reuseId, forIndexPath: indexPath) as! ExtractTableViewCell
        
        cell.extract = extractList?.getElementAtIndex(indexPath.row)

        return cell
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(60)
    }
    /*
    override public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.whiteColor()
        }
        else {
            cell.backgroundColor = RGBColor(r: 122, g: 183, b: 147, alpha: 0.1)
        }
    }
    */
    // MARK: -Class Properties and Functions
    class public var segueIdentifier: String {
        return "ExtractTableViewControllerSegue"
    }
}
