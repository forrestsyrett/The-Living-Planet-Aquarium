//
//  CurrentLocationController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


class CurrentLocationController {
    
    static var shared = CurrentLocationController()
    
    
    // CENTERED {40.53235,-111.89397}
    
     dynamic var coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(40.53228), CLLocationDegrees(-111.89397))
    
  // ENTRANCE //  dynamic var coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(40.5321), CLLocationDegrees(-111.89382))
    var exhibitName = ""
}
