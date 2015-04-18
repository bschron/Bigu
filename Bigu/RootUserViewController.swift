//
//  RootUserViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

class RootUserViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var firtnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var savingsLabel: UILabel!
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userImageViewSize = self.userImageView.frame.size
        self.userImageView.layer.cornerRadius = userImageViewSize.width / 2
        self.userImageView.layer.masksToBounds = true
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

}
