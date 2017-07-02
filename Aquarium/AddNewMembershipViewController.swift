//
//  BarcodeGeneratorViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 8/4/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit
import CoreImage
import UserNotifications
import SafariServices


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class AddNewMembershipViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet var membershipIDTextField: UITextField!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var expirationReminderSwitch: UISwitch!
    
    @IBOutlet weak var scanButton: UIButton!
    
    var membership: MembershipCard?
    
    var membershipCell = MembershipCardTableViewCell()
    var name = "first"
    var notificationController = NotificationController()
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient(self.view)
        transparentNavigationBar(self)
        
        
        expirationDatePicker.setValue(UIColor.white, forKey: "textColor")
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        membershipIDTextField.delegate = self
        transparentNavigationBar(self)
        roundCornerButtons(scanButton)
        
        if firstNameTextField.text?.isEmpty == true {
            saveButton.isEnabled = false
            
            dismissButton.layer.cornerRadius = 17.0
        }
        
    }
    
    
    @IBAction func firstNameNextButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func lastNameNextButtonTapped(_ sender: Any) {
        
        
    }
    
    
    @IBAction func membershipDoneButtonTapped(_ sender: Any) {
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if firstNameTextField.text == "" || membershipIDTextField.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
        
        if textField == self.firstNameTextField {
            self.lastNameTextField.becomeFirstResponder()
        }
        else if textField == self.lastNameTextField {
            self.membershipIDTextField.becomeFirstResponder()
        }
        else {
            membershipIDTextField.resignFirstResponder()
            firstNameTextField.resignFirstResponder()
            lastNameTextField.resignFirstResponder()
        }
        return true
        
    }
    
    
    @IBAction func memberIDTextFieldEditingChanged(_ sender: AnyObject) {
        
        if firstNameTextField.text?.characters.count <= 0 || membershipIDTextField.text?.characters.count <= 0 || lastNameTextField.text?.characters.count <= 0 {
            saveButton.isEnabled = false
        } else if membershipIDTextField.text?.characters.count > 0 {
            saveButton.isEnabled = true
        }
    }
    
    
    
    @IBAction func firstNameTextFieldEditingChanged(_ sender: Any) {
        
        if firstNameTextField.text?.characters.count <= 0 || membershipIDTextField.text?.characters.count <= 0 {
            saveButton.isEnabled = false
        } else if membershipIDTextField.text?.characters.count > 0 && self.firstNameTextField.text?.characters.count > 0 {
            saveButton.isEnabled = true
        }
        
        guard let name = self.firstNameTextField.text else { return }
        self.name = name
    }
    
    
    @IBAction func saveButton(_ sender: AnyObject) {
        
        if membership?.firstName == "" && membership?.memberID == "" { return }
        else {
            if let membership = self.membership {
                membership.firstName = self.firstNameTextField.text!
                membership.lastName = self.lastNameTextField.text!
                membership.memberID = self.membershipIDTextField.text!
                membership.barcodeImageString = self.membershipIDTextField.text!
                membership.expirationDate = self.expirationDatePicker.date
                
                
            } else {
                let newMembership = MembershipCard(memberID: self.membershipIDTextField.text!,
                                                   
                                                   firstName: self.firstNameTextField.text!,
                                                   lastName: lastNameTextField.text!,
                                                   barcodeImageString: membershipIDTextField.text!, expirationDate: expirationDatePicker.date)
                MembershipCardController.sharedMembershipController.addMembership(newMembership)
                self.membership = newMembership
                
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addedNewMembership"), object: nil)
        scheduleReminder()
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (requests) in
            
            print("HERE ARE ALL THE PENDING NOTIFICATIONS")
            for request in requests {
                print(request.identifier)
            }
        }
        
    }
    
    
    @IBAction func scanCardButtonTapped(_ sender: Any) {
        
        self.firstNameTextField.resignFirstResponder()
        self.lastNameTextField.resignFirstResponder()
        self.membershipIDTextField.resignFirstResponder()
    }
    
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func updateWithMembership(_ membership: MembershipCard) {
        self.membership = membership
        
        self.membershipIDTextField.text = membership.memberID
        self.firstNameTextField.text = membership.firstName
        self.lastNameTextField.text = membership.lastName
        self.expirationDatePicker.date = membership.expirationDate
    }
    
    
    func registerForNotificationCategories(name: String) {
        
        let center = UNUserNotificationCenter.current()
        
        let expirationDateReminder = UNNotificationAction(identifier: "renewMembership", title: "Renew Membership!", options: [.foreground])
        let remindMeAction = UNNotificationAction(identifier: "snooze", title: "Remind me later", options: [])
        
        let category = UNNotificationCategory(identifier: "membershipCategory", actions: [expirationDateReminder, remindMeAction], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        
    }
    

    
    
    func openNotificationSettings() {
        let alert = UIAlertController(title: "Notifications are not enabled", message: "To receive an expiration reminder, please change your notification settings.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (toSettings) in
            guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        
        alert.addAction(dismissAction)
        alert.addAction(settingsAction)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func scheduleReminder() {
        
  //      UNUserNotificationCenter.current().delegate = self
         let notificationStatus = UIApplication.shared.currentUserNotificationSettings?.types.contains([.alert]) ?? false
        
        self.registerForNotificationCategories(name: self.name)
        if expirationReminderSwitch.isOn {
            print("Switch is on")
            
            // Notifications not allowed. Prompt to open Settings
            if notificationStatus == false {
                
                self.openNotificationSettings()
                
            } else {
                // USer has allowed for notifications
                
                self.notificationController.scheduleExpirationReminder(date: self.expirationDatePicker.date, name: self.name)
                print("THIS IS THE DATE \(self.expirationDatePicker.date)")
                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
                    for request in requests {
                        print(request.identifier)
                        print(request)
                        if requests.count == 0 {
                            print("No notifications")
                        }
                    }
                })

                
            }
            
            
            
        }
    }
    
  
    // Test Button //
    @IBAction func notifyMeButtonTapped(_ sender: Any) {
        
      //  UNUserNotificationCenter.current().delegate = self
        
        self.registerForNotificationCategories(name: self.name)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Just a reminder"
        content.body = "\(self.name), your Membership expires in one week!"
        
        content.sound = UNNotificationSound(named: "fishFlop.m4r")
        content.categoryIdentifier = "membershipCategory"
        content.userInfo = ["url": "https://tickets.thelivingplanet.com/WebStore/Shop/ViewItems.aspx?CG=online&C=Memberships"]
        
        // Notification Request
        
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("There was an error \(error)")
            }
        }
        
        
    }
    
    @IBAction func unwindToAddNewMembership(segue: UIStoryboardSegue) {
        
        print("unwind")
        
        if (self.firstNameTextField.text?.characters.count > 0 || self.lastNameTextField.text?.characters.count > 0) && self.membershipIDTextField.text?.characters.count > 0 {
            self.saveButton.isEnabled = true
        }
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toBarcodeScanner" {
            
            let destination = segue.destination as! QRScannerViewController
            
            destination.scanType = "barCode"
            
            
            
        }
    }
}


