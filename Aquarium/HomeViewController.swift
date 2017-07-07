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
    @IBOutlet weak var lineOne: UIView!
    @IBOutlet weak var lineTwo: UIView!
    @IBOutlet weak var lineThree: UIView!
    @IBOutlet weak var lineFour: UIView!
    @IBOutlet weak var beaconInfoButton: UIButton!
    
    var locationManager: CLLocationManager!
    var regionName = "Area Name"
    var destinationName = "String"
    var notificationSwitch = true
    
    //   let rightGesture = UISwipeGestureRecognizer()
    
    
    // MARK: - Beacon Regions
    var jsaRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!, major: 10004, minor: 54482, identifier: "jsa")
    
    var sharkRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!, major: 10004, minor: 54481, identifier: "sharks")
    
     var theaterRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!, major: 10004, minor: 54483, identifier: "theater")
    
     var utahRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!, major: 10004, minor: 54484, identifier: "utah")
    
    
    
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
        
        self.jsaRegion.notifyOnEntry = true
        self.jsaRegion.notifyOnExit = true
        self.jsaRegion.notifyEntryStateOnDisplay = true
        
        self.utahRegion.notifyOnEntry = true
        self.utahRegion.notifyOnExit = true
        self.utahRegion.notifyEntryStateOnDisplay = true
        
        self.theaterRegion.notifyOnEntry = true
        self.theaterRegion.notifyOnExit = true
        self.theaterRegion.notifyEntryStateOnDisplay = true
        
        
        self.sharkRegion.notifyOnEntry = true
        self.sharkRegion.notifyOnExit = true
        self.sharkRegion.notifyEntryStateOnDisplay = true
        
        locationManager.startMonitoring(for: self.jsaRegion)
        locationManager.startMonitoring(for: self.sharkRegion)
        locationManager.startMonitoring(for: self.utahRegion)
        locationManager.startMonitoring(for: self.theaterRegion)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        animateLabel(welcomeLabel, animateTime: 0.5)
        animateLabel(livingPlanetLabel, animateTime: 1.0)
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
        locationManager.requestState(for: self.jsaRegion)
        locationManager.requestState(for: self.sharkRegion)
        locationManager.requestState(for: self.utahRegion)
        locationManager.requestState(for: self.theaterRegion)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        // Range specific beacons when entering a region
        
        switch region {
            
        case self.jsaRegion:
            if state == CLRegionState.inside {
                manager.startRangingBeacons(in: jsaRegion)
                print("inside jsa region")
                 self.regionName = region.identifier
            } else if state == CLRegionState.outside {
                manager.stopRangingBeacons(in: jsaRegion)
                print("Left jsa region")
            }
            
        case self.sharkRegion:
            if state == CLRegionState.inside {
                manager.startRangingBeacons(in: sharkRegion)
                print("inside shark region")
                self.regionName = region.identifier
            } else if state == CLRegionState.outside {
               manager.stopRangingBeacons(in: sharkRegion)
                print("Left shark region")
            }
            
        case self.utahRegion:
            if state == CLRegionState.inside {
                manager.startRangingBeacons(in: utahRegion)
                print("inside utah region")
                self.regionName = region.identifier
            } else if state == CLRegionState.outside {
                manager.stopRangingBeacons(in: utahRegion)
                print("Left utah region")
            }
            
        case self.theaterRegion:
            if state == CLRegionState.inside {
                manager.startRangingBeacons(in: theaterRegion)
                print("inside theater region")
                self.regionName = region.identifier
            } else if state == CLRegionState.outside {
                manager.stopRangingBeacons(in: theaterRegion)
                print("Left theater region")
            }


        default: print("no beacon state")

        }
  
    }
    
    func startScanning() {
        locationManager.startRangingBeacons(in: self.theaterRegion)
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
        
        print("Exited Region \(regionName)")
        
    }
    
    func update (_ distance: CLProximity) {
        
            switch distance {
            case .unknown:
                print("unknown")
                
            case.far:
                print("Far")
                
                
                switch self.regionName {
                    
                case self.jsaRegion.identifier:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "jsa"), object: nil)
                    CurrentLocationController.shared.exhibitName = "jsa"
                    
                case self.sharkRegion.identifier:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "sharks"), object: nil)
                    CurrentLocationController.shared.exhibitName = "sharks"
                    
                case self.theaterRegion.identifier:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "theater"), object: nil)
                    CurrentLocationController.shared.exhibitName = "theater"
                    
                case self.utahRegion.identifier:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "utah"), object: nil)
                    CurrentLocationController.shared.exhibitName = "utah"
                    
                default: break
                    
                }

            case.near:
                print("Near")
                
            case .immediate:
                print("immediate")
                
            }
        
    }
    ////////////////
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAnimalDetail" {
            
            let destinationViewController = segue.destination as! BeaconInfoViewController
           
            
            if self.destinationName == "sharks" {
                
                destinationViewController.image = #imageLiteral(resourceName: "oceans")
                destinationViewController.info = "Welcome to our 300,000 gallon shark tank! Here at the Loveland Living Planet Aquarium, we have many species of sharks in our shark tank. Can you spot them all? Tap on the camera logo below to open the Exhibit Scanner and see if you can find all the different sharks!"
                destinationViewController.titleLabel = "Shark Tank"
                destinationViewController.segueIdentifier = "sharks"
                destinationViewController.buttonLabel = "Notify me about the Shark Feeding!"
   
            }
            if self.destinationName == "jsa" {
                destinationViewController.image = #imageLiteral(resourceName: "antarcticAdventure2")
                destinationViewController.titleLabel = "Gentoo Penguins"
                destinationViewController.info = "Our aquarium is home to 19 Gentoo Penguins. See if you can spot the name bands on their flippers!\nWe feed our penguins at 4:00 PM every day."
                destinationViewController.segueIdentifier = "penguinEncounter"
                destinationViewController.buttonLabel = "Feed the Penguins!"
            }
        }
        
        
        if segue.identifier == "buyTickets" {
            
            let destination = segue.destination as! AnimalEncountersViewController
            destination.titleLabelString = "Tickets"
            destination.requestString = "https://tickets.thelivingplanet.com/WebStore/Shop/ViewItems.aspx?CG=online&C=Tickets"
        }
        if segue.identifier == "animalEncounters" {
            
            let destination = segue.destination as! AnimalEncountersViewController
            destination.titleLabelString = "Encounters"
            destination.requestString = "http://thelivingplanet.com/animalencounters/"
        }
        if segue.identifier == "donate" {
            
            let destination = segue.destination as! AnimalEncountersViewController
            destination.titleLabelString = "Help Us Grow"
            destination.requestString = "http://www.thelivingplanet.com/home-4/give/"
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
   
}
