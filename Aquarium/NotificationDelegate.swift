//
//  NotificationDelegate.swift
//  Aquarium
//
//  Created by Forrest Syrett on 3/14/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SafariServices

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationDelegate()
    let notificationController = NotificationController()
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("DID RECEIVE NOTIFICATION")
        
        if let websiteURL = userInfo["url"] as? String {
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
                
            case "renewMembership":
                // User tapped Renew Button
                print("Renewing")
                
                UIApplication.shared.open(URL(string: "\(websiteURL)")!, options: [:], completionHandler: nil)
                
             //   UIStoryboard().instantiateViewController(withIdentifier: "AnimalEncountersViewController")
                
                
                
                
            case "snooze":
                /// User Tapped Remind Me Later
                print("Remind me later")
                
                
                //604800 seconds in one week
                self.notificationController.scheduleRemindMeLater(timeInterval: 5.0, name: response.notification.request.identifier)
                break
            default:
                break
            }
            
        }
        completionHandler()
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("FOREGROUND DELEGATE")
        
        completionHandler( [.alert, .sound])
        
    }
}
