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
    
    static let shared = NotificationController()
    var name = ""
    
    // Event Notification
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
    
    

    
    // Membership Notification
    func scheduleExpirationReminder(date: Date, name: String) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        
        
        
        // Logic to schedule notification 2 weeks before expiration date
        var day = components.day
        var month = components.month
        
        if components.day! < 14 {
            
            
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
        content.title = "\(name), your Membership expires soon!"
        content.body = "Press for more options!"
        
        content.sound = UNNotificationSound(named: "fishFlop.m4r")
        content.categoryIdentifier = "membershipCategory"
        content.userInfo = ["url": "https://tickets.thelivingplanet.com/WebStore/shop/PassLookup.aspx?RedirectURL=Renewal&SalesChannelDetailID=120041"]
        
        
        
        // Notification Request
        
        let request = UNNotificationRequest(identifier: name, content: content, trigger: dateTrigger)
        // UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("There was an error \(error)")
            }
        }

    }
    
    
    func scheduleRemindMeLater(timeInterval: Double, name: String) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        //Notification Content
        let content = UNMutableNotificationContent()
        content.title = "Just a reminder"
        content.body = "\(name), your Membership expires soon!"
        
        content.sound = UNNotificationSound(named: "fishFlop.m4r")
        content.categoryIdentifier = "membershipCategory"
        content.userInfo = ["url": "https://tickets.thelivingplanet.com/WebStore/shop/PassLookup.aspx?RedirectURL=Renewal&SalesChannelDetailID=120041"]
        
        // Notification Request
        
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("There was an error \(error)")
            }
        }
    }
    


    
}

