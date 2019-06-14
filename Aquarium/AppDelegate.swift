//
//  AppDelegate.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/10/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit
import PushKit
import OneSignal
import UserNotifications
import Google
import GoogleSignIn
import Firebase
import EstimoteProximitySDK
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    
    var window: UIWindow?
    let notificationDelegate = NotificationDelegate()
    var proximityObserver: ProximityObserver!
    
    let center = UNUserNotificationCenter.current()
    
    let locationManager = CLLocationManager()
    let geofenceRegionCenter = CLLocationCoordinate2DMake(40.5321, -111.8940)
    
    // Use for testing geofencing with highway drive mode on simulator
    //let geofenceRegionCenter = CLLocationCoordinate2DMake(37.3324, -122.0558)
    
    // UNCOMMENT THIS FOR BEACONS
    var zones = [ProximityZone]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        FIRDatabase.database().goOnline()
        UITabBar.appearance().tintColor = UIColor.white
    
        
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "3090501c-b1b5-4a1f-9c02-cb3a768e71a7",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        center.delegate = notificationDelegate
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
        
       
        
        
        // Core location to start monitoring beacons in the background
        // Code in the Extension below will start and stop monitoring for beacons when the user is in/out of rnage from the aquarium.
        // This will save battery life and also not require the app to be launched to receive beacon notifications.
        
         self.locationManager.delegate = self
         self.locationManager.requestAlwaysAuthorization()
       

        // Notification Actions
        
        let openMembershipAction = UNNotificationAction(identifier: "membership", title: "Open Membership", options: [.foreground])
        let actionCategory = UNNotificationCategory(identifier: "entranceCategory", actions: [openMembershipAction], intentIdentifiers: [],options: [])
        center.setNotificationCategories([actionCategory])
        
        
        // BEACONS //////////////////////////////////////////////////////
    
        let cloudCredentials = CloudCredentials(appID: "llpa-app-lvz", appToken: "4474d4b135f8f962a85206c18ddd9165")
            
        self.proximityObserver = ProximityObserver(credentials: cloudCredentials, configuration: .default, onError: { (Error) in
            print(Error)
        })
        
    
     
        let coconutPuffZone = ProximityZone(tag: "Exhibit", range: ProximityRange.near)

        coconutPuffZone.onEnter = {
            zoneContext in
            let info = zoneContext.attachments["DoorName"]
            print("You are entering the \(info ?? "err")!")
            self.setupEntranceNotification()
        }
        coconutPuffZone.onExit = {
            zoneContext in
            let info = zoneContext.attachments["DoorName"]
            print("You are exiting the \(info ?? "err")!")
        }

   
        /////////
        
        let blueberryPieZone = ProximityZone(tag: "Exhibit", range: ProximityRange.near)
        blueberryPieZone.onEnter = {
            context in
            let info = context.attachments["Exhibit"]
            print("You are entering the \(info ?? "err")!")
            self.blueberryPieAlert()
        }
        blueberryPieZone.onExit = {
            context in
            let info = context.attachments["Exhibit"]
            print("You are exiting the \(info ?? "err")!")
        }
        
        /////////
        
        let icyMarshmallowZone = ProximityZone(tag: "Door", range: ProximityRange.near)

        icyMarshmallowZone.onEnter = {
            context in
            let info = context.attachments["DoorName"]
            print("You are entering the \(info ?? "err")!")
            self.icyMarshmallowAlert()
        }
        icyMarshmallowZone.onExit = {
            context in
            let info = context.attachments["Exhibit"]
            print("You are exiting the \(info ?? "err")!")
        }
        
        
        /////////
        
        let mintCocktailZone = ProximityZone(tag: "Exhibit", range: ProximityRange.near)
        mintCocktailZone.onEnter = {
            context in
            let info = context.attachments["Exhibit"]
            print("You are entering the \(info ?? "err")!")
            self.mintCocktailAlert()
        }
        mintCocktailZone.onExit = {
            context in
            let info = context.attachments["Exhibit"]
            print("You are exiting the \(info ?? "err")!")
        }
        
        
        
        
        //////////////////////////////////////
        //////// SET ZONES HERE///////////////
        //////////////////////////////////////
        
        zones = [coconutPuffZone, icyMarshmallowZone, blueberryPieZone, mintCocktailZone]
         startBeaconMonitoring(zones: zones)
        
        //////////////////////////////////////////////////////////////////
        
        // Stop Comment
       
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        return true
    }
    
 
    
    // Send notification when user enters through the front door.
    
    func setupEntranceNotification() {
        
        let content = UNMutableNotificationContent()
        
        
        let members = MembershipCardController.sharedMembershipController.memberships
        if members.count != 0 {
            let firstName = members[0].firstName
            
            content.title = "Welcome to the Aquarium, \(firstName)!"
            content.body = "Tap this notification to open up your membership card!"
        }
        else {
            content.title = "Welcome to the Aquarium!"
            content.body = "Tap this notification to purchase tickets!"
        }
        
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "entranceCategory"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let identifier = "MemberEntrance"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            print(error as Any)
        }
    }
    
    
    func blueberryPieAlert() {
        let content = UNMutableNotificationContent()
        content.title = "Blueberry Pie"
        content.body = "You're within range of the Blueberry Pie beacon!"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "blueberryPie"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            print(error as Any)
        }
        
    }
    func mintCocktailAlert() {
        let content = UNMutableNotificationContent()
        content.title = "Mint Cocktail"
        content.body = "You're within range of the Mint Cocktail beacon!"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "mintCocktail"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            print(error as Any)
        }
        
    }
    func icyMarshmallowAlert() {
        let content = UNMutableNotificationContent()
        content.title = "Icy Marshmallow"
        content.body = "You're within range of the Icy Marshmallow beacon!"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "icyMarshmallow"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            print(error as Any)
        }
        
    }
    
    
    // Beacon monitoring functions
    
  
    func startBeaconMonitoring(zones: [ProximityZone]) {
        self.proximityObserver.startObserving(zones)
    }
    
    func stopBeaconMonitoring() {
        self.proximityObserver.stopObservingZones()
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "enteringBackground"), object: nil)
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FIRDatabase.database().goOffline()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        FIRDatabase.database().goOnline()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "active"), object: nil)
        
        
        func applicationDidBecomeActive(_ application: UIApplication) {
            guard let shortcut = shortCutItem else { return }
            
            //            MembershipShortcutAction(shortcut)
            
            shortCutItem = nil
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        
        print(token)
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
        
        
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let handledShortcutItem = MembershipShortcutAction(shortcutItem)
        
        completionHandler(handledShortcutItem)
    }
    
    
    
    enum ShortCutIdentifier: String {
        case OpenMobileMembership = "Memberships"
        case QRScanner = "Scanner"
        case Events = "Events"
        
        
        init?(shortcutItem: String) {
            guard let last = shortcutItem.components(separatedBy: ".").last else { return nil }
            self.init(rawValue: last)
        }
        
        
    }
    
    var shortCutItem: UIApplicationShortcutItem?
    
    
    
    func MembershipShortcutAction(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        
      let shortcutType = shortcutItem.type
        guard let shortCutIdentifier = ShortCutIdentifier(shortcutItem: shortcutType) else { return false }
        
        
        switch shortCutIdentifier {
            
        case .OpenMobileMembership:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = storyBoard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            self.window?.rootViewController = tabBar
            tabBar.selectedIndex = 2
            let navigationController = tabBar.selectedViewController as! UINavigationController
            let memberships = storyBoard.instantiateViewController(withIdentifier: "membershipsViewController") as! MembershipListTableViewController
            transparentNavigationBar(memberships)
            navigationController.pushViewController(memberships, animated: true)

        case .QRScanner:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = storyBoard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            self.window?.rootViewController = tabBar
            tabBar.selectedIndex = 4
            
        case .Events:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = storyBoard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            self.window?.rootViewController = tabBar
            tabBar.selectedIndex = 3

    
        }

        return true
    }
    
    
  
    
}


extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .denied: return
        case .notDetermined: self.locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            let aquariumRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 300.0, identifier: "aquarium")
            aquariumRegion.notifyOnEntry = true
            aquariumRegion.notifyOnExit = true
            startBeaconMonitoring(zones: zones)
            locationManager.startMonitoring(for: aquariumRegion)
        case .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            let aquariumRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 300.0, identifier: "aquarium")
            aquariumRegion.notifyOnEntry = true
            aquariumRegion.notifyOnExit = true
            startBeaconMonitoring(zones: zones)
            locationManager.startMonitoring(for: aquariumRegion)
        default: break
        }
    }
   
    
    // Region monitoring events to open app in the background upon arrival at the Aquarium.
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.stopBeaconMonitoring()
        print("stop beacon monitoring")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.startBeaconMonitoring(zones: zones)
        print("Start beacon monitoring")
    }
    

  
}


