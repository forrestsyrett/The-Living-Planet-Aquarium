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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        UITabBar.appearance().tintColor = UIColor.white
        
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "3090501c-b1b5-4a1f-9c02-cb3a768e71a7")
        
        application.registerForRemoteNotifications()
        
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
        
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "enteringBackground"), object: nil)
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
        
        MembershipShortcutAction(shortcutItem)
    }
    
    
    
    enum ShortCutIdentifier: String {
        case OpenMobileMembership = "Open Mobile Membership"
        case QRScanner = "QR Scanner"
        
        init?(shortcutItem: String) {
            guard let last = shortcutItem.components(separatedBy: ".").last else { return nil }
            self.init(rawValue: last)
        }
        
        
    }
    
    var shortCutItem: UIApplicationShortcutItem?
    
    
    
    func MembershipShortcutAction(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        if let index = shortcutItem.userInfo?["TabIndex"] as? Int {
            (window?.rootViewController as? UITabBarController)?.selectedIndex = index
            
        }
        
        return true
    }
}


