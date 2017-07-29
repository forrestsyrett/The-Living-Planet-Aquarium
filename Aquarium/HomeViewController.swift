//
//  HomeViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/21/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit
import SafariServices
import CoreLocation
import UserNotifications
import SAConfettiView

class HomeViewController: UIViewController, UITabBarControllerDelegate, UNUserNotificationCenterDelegate, UITabBarDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var buyTicketsLabel: UIButton!
    @IBOutlet weak var becomeAMemberLabel: UIButton!
    @IBOutlet weak var animalEncountersLabel: UIButton!
    @IBOutlet weak var directionsLabel: UIButton!
    @IBOutlet weak var donateLabel: UIButton!
    @IBOutlet weak var lineOne: UIView!
    @IBOutlet weak var lineTwo: UIView!
    @IBOutlet weak var lineThree: UIView!
    @IBOutlet weak var lineFour: UIView!
    @IBOutlet weak var socialMediaTrayWidth: NSLayoutConstraint!
    @IBOutlet weak var logoButton: UIButton!
    @IBOutlet weak var confettiView: SAConfettiView!
    
    var destinationName = "String"
    var notificationSwitch = true
    var counter = 0
    
    // MARK: - Beacon Regions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tabBarTint(view: self)
        gradient(self.view)
        transparentNavigationBar(self)
        confettiView.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateLabel(welcomeLabel, animateTime: 0.5)
        animateLines(lineOne, animateTime: 0.75)
        animateLines(lineTwo, animateTime: 1.0)
        animateLines(lineThree, animateTime: 1.5)
        animateLines(lineFour, animateTime: 2.0)

        
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
    }
    
 

    @IBAction func logoButtonTapped(_ sender: Any) {
      
        counter += 1
        
        if counter == 20 {
            if !confettiView.isActive() {
                confettiView.startConfetti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.confettiView.stopConfetti()
            })
        }
        }
        if counter > 20 {
            counter = 0
        }
 
    }
    
    
    // MARK: - Notification Code
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let openMemberships = UNNotificationAction(identifier: "openMemberships", title: "Open Membership", options: .foreground)
        let openFeedings = UNNotificationAction(identifier: "openFeedings", title: "Check Feeding Schedule", options: .foreground)
        let category = UNNotificationCategory(identifier: "openTabs", actions: [openMemberships, openFeedings], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    
    func scheduleWelcomeNotification(at date: Date) {
        
        registerCategories()
        
        
        let immediateTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        
        // Notification Content And Identifiers
        let content = UNMutableNotificationContent()
        content.title = "Welcome to the Aquarium!"
        content.body = "Press for more options!"
        
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "openTabs"
        content.userInfo = ["customData": " test"]
        
        // Notification Request
        let request = UNNotificationRequest(identifier: "openMemberships", content: content, trigger: immediateTrigger)
        
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("There was an error \(error)")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
            case "openMemberships":
                // User tapped Open Memberships Button
                print("Show more information…")
                
                let window = UIApplication.shared.delegate?.window
                if window??.rootViewController as? UITabBarController != nil {
                    let tabBarController = window!?.rootViewController as! UITabBarController
                    tabBarController.selectedIndex = 3
                }
            case "openFeedings":
                /// USer tapped open feedings button
                let window = UIApplication.shared.delegate?.window
                if window??.rootViewController as? UITabBarController != nil {
                    let tabBarController = window!?.rootViewController as! UITabBarController
                    tabBarController.selectedIndex = 1
                }
                break
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    
    
    // MARK: Social Media Actions
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        UIApplication.tryURL(urls: [
            "fb://profile/138949625025", // App
            "http://www.facebook.com/138949625025" //Website
            ])
    }
    
    @IBAction func instagramButtonTapped(_ sender: Any) {
        UIApplication.tryURL(urls: [
            "instagram://user?username=lovelandlivingplanet", // App
            "http://www.instagram.com/lovelandlivingplanet" //Website
            ])
    }
     
    @IBAction func twitterButtonTapped(_ sender: Any) {
        UIApplication.tryURL(urls: [
            "twitter://user?screen_name=livingplanetUT", // App
            "http://www.twitter.com/livingplanetUT" //Website
            ])
    }
    
    ////////////////
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if segue.identifier == "buyTickets" {
            
            let destination = segue.destination as! HomeWebViewController
            destination.buttonHidden = true
            destination.titleLabelString = "Tickets"
            destination.requestString = "https://tickets.thelivingplanet.com/WebStore/Shop/ViewItems.aspx?CG=online&C=Tickets"
        }
        if segue.identifier == "animalEncounters" {
            
            let destination = segue.destination as! HomeWebViewController
            destination.buttonHidden = true
            destination.titleLabelString = "Encounters"
            destination.requestString = "http://thelivingplanet.com/animalencounters/"
        }
        if segue.identifier == "donate" {
            
            let destination = segue.destination as! HomeWebViewController
            destination.buttonHidden = true
            destination.titleLabelString = "Help Us Grow"
            destination.requestString = "http://www.thelivingplanet.com/home-4/give/"
        }
    }

    
    
}
