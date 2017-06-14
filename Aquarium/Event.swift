//
//  Event.swift
//  Aquarium
//
//  Created by Forrest Syrett on 5/31/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


class Event: Mappable {
    
    
    
    var eventName: String?
    var eventDate: String?
    var scheduled: Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        eventName <- map["summary"]
        eventDate <- map["start.dateTime"]
        
    }
    
}


class AllEvents: Mappable {
    
    var events: [Event]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.events <- map["items"]
    }
    
    
}

