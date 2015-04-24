//
//  RootUserViewController.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/17/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import Models

class RootUserViewController: UIViewController, UserHandlingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    private var rootUser: RootUser {
        get {
            return RootUser.singleton
        }
    }
    private var _intValues: Array<Int>? = nil
    private var integerValues: [Int] {
        if self._intValues == nil {
            self._intValues = []
            for i in 1...50 {
                self._intValues! += [i]
            }
        }
        return self._intValues!
    }
    private let floatingPointValues: [Float] = [0, 0.5]
    
    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    private var userImageViewInvisibleSuperLayer: UIView!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var savingsLabel: UILabel!
    private var userImageTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var rideListTableView: UITableView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var taxValuePicker: UIPickerView!
    @IBOutlet weak var taxValueLabel: UIButton!
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.rideListTableView.registerNib(UINib(nibName: "RideTableViewCell", bundle: nil), forCellReuseIdentifier: RideTableViewCell.reuseId)
        
        self.sideView.backgroundColor = RGBColor(r: 1, g: 63, b: 26, alpha: 1)
        
        self.userImageView.layer.cornerRadius = self.userImageView.layer.frame.width / 2
        self.userImageView.layer.masksToBounds = true
        self.rootUser.handler = self
        
        self.userImageViewInvisibleSuperLayer = UIView(frame: self.userImageView.frame)
        self.userImageViewInvisibleSuperLayer.layer.cornerRadius = self.userImageView.layer.cornerRadius
        self.userImageViewInvisibleSuperLayer.layer.masksToBounds = self.userImageView.layer.masksToBounds
        self.userImageViewInvisibleSuperLayer.center = self.userImageView.center
        self.userImageViewInvisibleSuperLayer.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(CGFloat(0))
        self.view.insertSubview(self.userImageViewInvisibleSuperLayer, aboveSubview: self.userImageView)
        self.userImageTapGesture = UITapGestureRecognizer(target: self, action: "userImageTapped:")
        self.userImageViewInvisibleSuperLayer.addGestureRecognizer(self.userImageTapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUsersData()
        self.rideListTableView.reloadData()
        self.setTaxValueLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self._intValues = nil
    }
    
    func displayPhotoLibraryPicker () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        
        self.presentViewController(imagePicker, animated: true,
            completion: nil)
    }
    
    private func setTaxValueLabel() {
        self.taxValueLabel.setTitle("\(RootUser.singleton.taxValue)", forState: UIControlState.allZeros)
    }
    
    // MARK: actions
    @IBAction func firtsnameFieldChanged(sender: AnyObject) {
        self.rootUser.name = self.firstnameTextField.text
    }
    @IBAction func lastnameFieldChanged(sender: AnyObject) {
        self.rootUser.surName = self.lastnameTextField.text
    }
    @IBAction func nicknameFieldChanged(sender: AnyObject) {
        self.rootUser.nickName = self.nicknameTextField.text
    }
    @IBAction func closeKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    func userImageTapped(sender: UITapGestureRecognizer) {
        self.displayPhotoLibraryPicker()
    }
    
    // MARK: -Protocols
    // MARK: UserHandlingProtocol
    func reloadUsersData() {
        self.title = rootUser.nickName != "" ? rootUser.nickName : rootUser.name != "" ? rootUser.name : "User"
        self.savingsLabel.text = "\(self.rootUser.savings)"
        self.firstnameTextField.text = self.rootUser.name
        self.lastnameTextField.text = self.rootUser.surName
        self.nicknameTextField.text = self.rootUser.nickName
        self.userImageView.image = self.rootUser.userImage
    }
    // MARK: UIImagePickekControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.rootUser.userImage = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Rides History" : nil
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RideListManager.rideListSingleton.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let ride = RideListManager.rideListSingleton.list.getElementAtIndex(row)
        let cell = self.rideListTableView.dequeueReusableCellWithIdentifier(RideTableViewCell.reuseId, forIndexPath: indexPath) as! RideTableViewCell
        cell.ride = ride
        
        return cell
    }
    
    // MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var str: NSAttributedString?
        
        if component == 0 {
            str = NSAttributedString(string: "\(self.integerValues[row])", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        else if component == 1 {
            str = NSAttributedString(string: "\(self.floatingPointValues[row])", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        
        return str
    }
    
    // MARK: UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? self.integerValues.count : self.floatingPointValues.count
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let pickerWidth = pickerView.bounds.size.width
        return component == 0 ? (2 * pickerWidth) / 3 : pickerWidth / 3
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
