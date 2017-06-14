//
//  NotificationDelegate.swift
//  Aquarium
//
//  Created by TLPAAdmin on 3/14/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationDelegate()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("presenting...")
        completionHandler([.alert, .sound])
    }
    
    
    var delegate = UNUserNotificationCenter.current().delegate
    
}
