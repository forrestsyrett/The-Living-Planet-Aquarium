//
//  Feeding.swift
//  Aquarium
//
//  Created by Forrest Syrett on 7/21/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit
import Foundation

enum Feeding {
    case shark
    case penguin
    case archerfish
    case riverGiant
    case piranha
    
    struct Info {
        var animalName: String
        var notificationTitle: String
        var time: Date
        var hour: Int
        var minute: Int
        var timeString: String
        var weekdays: [Int: Bool]
        var image: UIImage?
    }
    
    var info: Info {
        let now = Date()
        let calendar = Calendar.current
        
        switch self {
        case .shark:
            let time = (calendar as NSCalendar).date(bySettingHour: 13, minute: 30, second: 0, of: now, options: .matchStrictly)!
            return Info(animalName: "Shark Feed", notificationTitle: "Shark feeding at \(Feeding.dateFormatter.string(from: time))!", time: time, hour: 13, minute: 15, timeString: Feeding.dateFormatter.string(from: time), weekdays: [1: true, 3: true, 5: true, 7: true], image: UIImage(named: "sharkFeed")!)
        case .penguin:
            let time = (calendar as NSCalendar).date(bySettingHour: 16, minute: 00, second: 0, of: now, options: .matchStrictly)!
            return Info(animalName: "Penguin Feed", notificationTitle: "Penguin feeding at \(Feeding.dateFormatter.string(from: time))!", time: time, hour: 15, minute: 45, timeString: Feeding.dateFormatter.string(from: time), weekdays: [1: true, 2: true, 3: true, 4: true, 5: true, 6: true, 7: true], image: UIImage(named: "penguinFeed")!)
        case .archerfish:
            let time = (calendar as NSCalendar).date(bySettingHour: 14, minute: 30, second: 0, of: now, options: .matchStrictly)!
            return Info(animalName: "Archerfish Feed", notificationTitle: "Archerfish feeding at \(Feeding.dateFormatter.string(from: time))!", time: time, hour: 14, minute: 15, timeString: Feeding.dateFormatter.string(from: time), weekdays: [2: true, 5: true, 7: true], image: UIImage(named: "archerfishFeed")!)
        case .riverGiant:
            let time = (calendar as NSCalendar).date(bySettingHour: 14, minute: 30, second: 0, of: now, options: .matchStrictly)!
            return Info(animalName: "River Giants Feed", notificationTitle: "River Giants feeding at \(Feeding.dateFormatter.string(from: time))!", time: time, hour: 14, minute: 15, timeString: Feeding.dateFormatter.string(from: time), weekdays: [3: true, 5: true, 7: true], image: UIImage(named: "riverGiantsFeed")!)
        case .piranha:
            let time = (calendar as NSCalendar).date(bySettingHour: 11, minute: 00, second: 0, of: now, options: .matchStrictly)!
            return Info(animalName: "Piranha Feed", notificationTitle: "Piranha feeding at \(Feeding.dateFormatter.string(from: time))!", time: time, hour: 10, minute: 45, timeString: Feeding.dateFormatter.string(from: time), weekdays: [3: true, 5: true], image: UIImage(named: "piranhaFeed")!)
        }
    }
    
    static func feeding(on day: Int) -> [Feeding] {
        let filtered = allFeedings.filter { $0.info.weekdays.keys.contains(day) }
        return filtered.sorted {
            if $0.info.time == $0.info.time {
                return $0.info.time.timeIntervalSince1970 < $1.info.time.timeIntervalSince1970
            }
            return $0.info.notificationTitle < $1.info.notificationTitle
        }
    }
    
    static var allFeedings = [Feeding.shark, .penguin, .archerfish, .riverGiant, .piranha]
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    } ()
    
}


//NSLocalizedString("String text", comment: "Explanation of where it is used to help a translator")




