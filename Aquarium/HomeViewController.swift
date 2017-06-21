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

class HomeViewController: UIViewController, UITabBarControllerDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, UITabBarDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var livingPlanetLabel: UILabel!
    @IBOutlet weak var buyTicketsLabel: UIButton!
    @IBOutlet weak var becomeAMemberLabel: UIButton!
    @IBOutlet weak var animalEncountersLabel: UIButton!
    @IBOutlet weak var directionsLabel: UIButton!
    @IBOutlet weak var donateLabel: UIButton!
    @IBOutlet weak var smallLogo: UIImageView!
    @IBOutlet weak var lineOne: UIView!
    @IBOutlet weak var lineTwo: UIView!
    @IBOutlet weak var lineThree: UIView!
    @IBOutlet weak var lineFour: UIView!
    @IBOutlet weak var aquariumLabel: UILabel!
    @IBOutlet weak var beaconInfoButton: UIButton!
    
    var locationManager: CLLocationManager!
    var regionName = "Area Name"
    var destinationName = "String"
    var notificationSwitch = true
    
    
    //   let rightGesture = UISwipeGestureRecognizer()
    
    
    // MARK: - Beacon Regions
    var entranceRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!, major: 10004, minor: 54482, identifier: "Entrance")
    
    var sharkRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!, major: 10004, minor: 54481, identifier: "Sharks")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarTint(view: self)
        gradient(self.view)
        transparentNavigationBar(self)
                
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        roundViews(beaconInfoButton, cornerRadius: 0.77)
        shadow(beaconInfoButton)
        
        beaconInfoButton.alpha = 0.0
        
        self.entranceRegion.notifyOnEntry = true
        self.entranceRegion.notifyOnExit = true
        self.entranceRegion.notifyEntryStateOnDisplay = true
        
        
        self.sharkRegion.notifyOnEntry = true
        self.sharkRegion.notifyOnExit = true
        self.sharkRegion.notifyEntryStateOnDisplay = true
        
        locationManager.startMonitoring(for: self.entranceRegion)
        locationManager.startMonitoring(for: self.sharkRegion)
        
        //   self.rightGesture.direction = .right
        //   self.view.addGestureRecognizer(rightGesture)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateImage(smallLogo, animateTime: 2.0)
        animateLabel(welcomeLabel, animateTime: 0.5)
        animateLabel(livingPlanetLabel, animateTime: 1.0)
        animateLabel(aquariumLabel, animateTime: 1.0)
        animateLines(lineOne, animateTime: 0.75)
        animateLines(lineTwo, animateTime: 1.0)
        animateLines(lineThree, animateTime: 1.5)
        animateLines(lineFour, animateTime: 2.0)
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
        
    }
    
    
    // Beacon Code
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: self.entranceRegion)
        locationManager.requestState(for: self.sharkRegion)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        if region == self.entranceRegion {
            if state == CLRegionState.inside {
                manager.startRangingBeacons(in: entranceRegion)
                print("inside entrance region")
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.beaconInfoButton.alpha = 1.0
                    
                })
                self.destinationName = "Penguins"
                self.regionName = region.identifier
                
            }
            
        }
        if state == CLRegionState.outside {
            manager.stopRangingBeacons(in: entranceRegion)
            print("Left Entrance region")
        }
        
        
        if region == self.sharkRegion {
            if state == CLRegionState.inside {
                manager.startRangingBeacons(in: sharkRegion)
                print("inside shark region")
                beaconInfoButton.alpha = 0.0
                beaconInfoButton.setTitle("Info", for: .normal)
                UIView.animate(withDuration: 1.0, animations: {
                    self.beaconInfoButton.alpha = 1.0
                    
                })
                self.destinationName = "Sharks"
            }
            
        }
        if state == CLRegionState.outside {
            manager.stopRangingBeacons(in: sharkRegion)
            print("outside shark region")
            UIView.animate(withDuration: 1.0, animations: {
                self.beaconInfoButton.alpha = 0.0
            })
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        print("Did range beacons")
        if beacons.count > 0 {
            update(beacons[0].proximity)
        } else {
            update(.unknown)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        let regionIdentifier = region.identifier
        self.regionName = region.identifier
        
        
        print("Entered Region \(regionIdentifier)")
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        let regionName = region.identifier
        
        self.view.backgroundColor = UIColor.purple
        
        print("Exited Region \(regionName)")
        
        if region == self.entranceRegion {
            self.notificationSwitch = true
        }
    }
    
    func update (_ distance: CLProximity) {
        
        UIView.animate(withDuration: 0.4) {
            switch distance {
            case .unknown:
                print("unknown")
                
            case.far:
                print("Far")
                
                if self.regionName == "Entrance" {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "jsa"), object: nil)
                    
                    // Sets the currentLocationController "Current Location" String
                    CurrentLocationController.shared.exhibitName = "jsa"
                    
                }
                if self.regionName == "Sharks" {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "sharks"), object: nil)
                    CurrentLocationController.shared.exhibitName = "sharks"
                }
                
            case.near:
                print("Near")
                UIView.animate(withDuration: 1.0, animations: {
                    self.beaconInfoButton.alpha = 1.0
                })
                
                if self.notificationSwitch == true {
                    self.scheduleWelcomeNotification(at: Date())
                    self.notificationSwitch = false
                }
            case .immediate:
                print("immediate")
                
            }
        }
    }
    ////////////////
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAnimalDetail" {
            
            let destinationViewController = segue.destination as! BeaconInfoViewController
            UIView.animate(withDuration: 0.3, animations: {
                self.smallLogo.alpha = 0.0
                
            })
            
            if self.destinationName == "Sharks" {
                
                destinationViewController.image = "zebraShark"
                destinationViewController.info = "Welcome to our 300,000 gallon shark tank! Here at the Loveland Living Planet Aquarium, we have 8 species of sharks in our shark tank. Can you spot them all?"
                destinationViewController.titleLabel = "Shark Tank"
                destinationViewController.segueIdentifier = "sharks"
                destinationViewController.buttonLabel = "Notify me about the Shark Feeding!"
                
                
                
                
            }
            if self.destinationName == "Penguins" {
                destinationViewController.image = "penguins"
                destinationViewController.titleLabel = "Gentoo Penguins"
                destinationViewController.info = "Our aquarium is home to 19 Gentoo Penguins. See if you can spot the name bands on their flippers!\nWe feed our penguins at 4:00 PM every day."
                destinationViewController.segueIdentifier = "penguinEncounter"
                destinationViewController.buttonLabel = "Feed the Penguins!"
                
                
            }
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
    
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
    //
    //        completionHandler([.alert, .sound])
    //    }
    //
    
    
    // MARK: - Beacon Button Animations
    
    @IBAction func touchDown(_ sender: Any) {
        
        buttonBounceTouchDown(self.beaconInfoButton)
    }
    
    @IBAction func touchDragExit(_ sender: Any) {
        buttonBounceTouchUp(self.beaconInfoButton)
    }
    
    @IBAction func touchDragEnter(_ sender: Any) {
        buttonBounceTouchDown(self.beaconInfoButton)
    }
    
    @IBAction func touchUpInside(_ sender: Any) {
        buttonBounceTouchUp(self.beaconInfoButton)
    }
    
    
    // CODE TO ALLOW FOR SWIPING BETWEEN TABS
    
    /* func goToPreviousTab(gesture: UIGestureRecognizer) {
     print("Swipe!")
     guard let tabBarController = self.tabBarController,
     let selectedIndex = self.tabBarController?.selectedIndex,
     let selectedController = tabBarController.selectedViewController,
     let viewControllers = tabBarController.viewControllers, selectedIndex >= 0 else { return }
     print("selectedIndex \(selectedIndex)")
     let nextIndex = selectedIndex + 1
     let fromView = selectedController.view
     let toView = viewControllers[nextIndex].view
     print("|NewIndex \(nextIndex)")
     UIView.transition(  from: fromView!,
     to: toView!,
     duration: 0.5,
     options: UIViewAnimationOptions.transitionCrossDissolve,
     completion: {(finished : Bool) -> () in
     if (finished) {
     tabBarController.selectedIndex = nextIndex
     }
     })
     
     }
     
     @IBAction func rightSwipe(_ sender: Any) {
     
     self.goToPreviousTab(gesture: self.rightGesture)
     }
     
     */
    
    
    @IBAction func buyTicketsButtonTapped(_ sender: AnyObject) {
        let safariVC = SFSafariViewController(url: URL(string: "https://tickets.thelivingplanet.com/WebStore/Shop/ViewItems.aspx?CG=online&C=Tickets")!)
        safariVC.preferredControlTintColor = UIColor.white
        safariVC.preferredBarTintColor = UIColor(red:0.00, green:0.10, blue:0.20, alpha:1.00)
        present(safariVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func becomeAMemberButtonTapped(_ sender: AnyObject) {
        //        let safariVC = SFSafariViewController(url: URL(string: "https://tickets.thelivingplanet.com/WebStore/Shop/ViewItems.aspx?CG=online&C=Memberships")!)
        //        safariVC.preferredControlTintColor = UIColor.white
        //        safariVC.preferredBarTintColor = UIColor(red:0.00, green:0.10, blue:0.20, alpha:1.00)
        //        present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func donateButtonTapped(_ sender: AnyObject) {
        let safariVC = SFSafariViewController(url: URL(string: "http://www.thelivingplanet.com/home-4/give/")!)
        safariVC.preferredControlTintColor = UIColor.white
        safariVC.preferredBarTintColor = UIColor(red:0.00, green:0.10, blue:0.20, alpha:1.00)
        present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func directionButtonTapped(_ sender: AnyObject) {
        
        
    }
    
    
}
