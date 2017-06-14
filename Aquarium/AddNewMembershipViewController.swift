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
        
    }
    
    
    @IBAction func scanCardButtonTapped(_ sender: Any) {
        
        
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
    
    
    func registerForNotificationCategories() {
        let center = UNUserNotificationCenter.current()
        
        
        let expirationDateReminder = UNNotificationAction(identifier: (self.name), title: "Renew Membership!", options: .foreground)
        let remindMeAction = UNNotificationAction(identifier: "reminder", title: "Remind me later", options: [])
        
        let category = UNNotificationCategory(identifier: "membershipCategory", actions: [expirationDateReminder, remindMeAction], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        
    }
    
    
    
    func scheduleExpirationReminder(date: Date) {
        
        registerForNotificationCategories()
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        
        
        
        // Logic to schedule notification 2 weeks before expiration date
        var day = components.day
        var month = components.month
        
        if components.day < 14 {
            
            
            enum Months: Int {
                case Jan = 1
                case Feb
                case March
                case April
                case May
                case June
                case July
                case August
                case Sept
                case Oct
                case Nov
                case Dec
            }
            
            
            let dayDifference = components.day! - 14
            print("DayDifference = \(dayDifference)")
            month! -= 1
            day! = 30 + dayDifference
            
            /* switch components.month! {
             
             case Months.Feb.rawValue:
             day! = 29 + dayDifference
             
             case Months.April.rawValue, Months.June.rawValue, Months.Sept.rawValue, Months.Nov.rawValue:
             day! = 30 + dayDifference
             
             case Months.Jan.rawValue, Months.March.rawValue, Months.May.rawValue, Months.July.rawValue, Months.August.rawValue, Months.Oct.rawValue, Months.Dec.rawValue:
             day! = 31 + dayDifference
             
             default: break
             } */
            
            if dayDifference == 0 {
                day! = 1
            }
            
        } else  {
            day = components.day! - 14
        }
        
        let newComponents = DateComponents(
            
            
            calendar: calendar,
            timeZone: .current,
            year: components.year,
            month: month,
            day: day,
            hour: components.hour,
            minute: components.minute)
        
        
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        
        //Notification Content
        let content = UNMutableNotificationContent()
        if let name = self.firstNameTextField.text {
            self.name = name
            content.title = "\(self.name), your Membership expires soon!"
        }
        content.body = "Press for more options!"
        
        content.sound = UNNotificationSound(named: "fishFlop.m4r")
        content.categoryIdentifier = "membershipCategory"
        content.userInfo = ["url": "https://tickets.thelivingplanet.com/WebStore/Shop/ViewItems.aspx?CG=online&C=Memberships"]
        
        
        
        // Notification Request
        
        let request = UNNotificationRequest(identifier: self.name, content: content, trigger: dateTrigger)
        //        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("There was an error \(error)")
            }
        }
    }
    
    
    
    
    func scheduleReminder() {
        if expirationReminderSwitch.isOn {
            print("Switch is on")
            scheduleExpirationReminder(date: self.expirationDatePicker.date)
            
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
                for request in requests {
                    print(request.identifier)
                }
            })
            
        }
    }
    
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let websiteURL = userInfo["url"] as? String {
            
            
            
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
                
            case "\(self.name)":
                // User tapped Renew Button
                print("Renewing")
                let safariVC = SFSafariViewController(url: URL(string: "\(websiteURL)")!)
                
                self.present(safariVC, animated: true, completion: nil)
                
            case "reminder":
                /// User Tapped Remind Me Later
                print("Remind me later")
                print("Remind me later")
                print("Remind me later")
                print("Remind me later")
                print("Remind me later")
                
                scheduleRemindMeLater(timeInterval: 604800.00)
                
                //604800 seconds in one week
                break
            default:
                break
            }
            
        }
        completionHandler()
    }
    
    
    
    
    
    // Mark: - Remind Me later Action Tapped
    func scheduleRemindMeLater(timeInterval: Double) {
        
        registerForNotificationCategories()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        //Notification Content
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
    
    @IBAction func notifyMeButtonTapped(_ sender: Any) {
        
        registerForNotificationCategories()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
        
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




extension AddNewMembershipViewController: UNUserNotificationCenterDelegate {
    
    
    
}




