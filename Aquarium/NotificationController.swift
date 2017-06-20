//
//  NotificationController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 7/18/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationController {
    

    func scheduleNewNotification(on date: Date, event: Event) {
        
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Event alert!"
        content.body = "\(event.eventName ?? "Your event") starts in 15 minutes!"
        content.sound = UNNotificationSound(named: "fishFlop.m4r")
        content.userInfo = [event.eventName!: event.eventDate!]
        
        let request = UNNotificationRequest(identifier: "\(event.eventName ?? "Event Name") \(event.eventDate ?? "Event Date")", content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("There was an error displaying the notification: \(error)")
            }
        }
        
    }
}



