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
    
    // Assign actions to the notification
    // Add a snooze action that schedules a new notification 5 min before the feeding
    
    
    func scheduleNotification(for feeding: Feeding, onWeekday weekday: Int, scheduled: Bool) {
        
        /*   let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
         
         let now = Date()
         var fireDate = (gregorian as NSCalendar).date(bySettingUnit: .weekday, value: weekday, of: now, options: [])!
         fireDate = (gregorian as NSCalendar).date(bySettingUnit: .hour, value: feeding.info.hour, of: fireDate, options: [])!
         fireDate = (gregorian as NSCalendar).date(bySettingUnit: .minute, value: feeding.info.minute, of: fireDate, options: [])!
         
         
         let feedNotification = UILocalNotification()
         let userInfoDictionary = [String(weekday) : feeding.info.animalName]
         
         feedNotification.fireDate = fireDate
         feedNotification.alertBody = feeding.info.notificationTitle
         feedNotification.timeZone = TimeZone.current
         feedNotification.repeatInterval = .weekOfYear
         feedNotification.userInfo = userInfoDictionary
         feedNotification.soundName = "fishFlop.m4r"
         
         
         if scheduled {
         UIApplication.shared.scheduleLocalNotification(feedNotification)
         }
         if scheduled == false {
         UIApplication.shared.cancelLocalNotification(feedNotification)
         }
         */
    }
    
    
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



