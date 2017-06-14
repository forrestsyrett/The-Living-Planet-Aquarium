//
//  Annotations.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import MapKit


enum AnnotationTypes: Int {
    
    case Utah = 0
    case Jsa = 1
    case Giftshop = 2
    case Oceans = 3
    case Asia = 4
    case Tukis = 5
    case AntarcticAdventure = 6
    case Banquet = 7
    case Bathrooms = 8
    case Jellies = 9
    case Elevator = 10
    case DeepSeaLab = 11
    case CurrentLocation = 12
    case Theater = 13
    case EducationCenter = 14
    case MothersRoom = 15
    case Cafe = 16
}


class Annotation: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: AnnotationTypes
    
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, type: AnnotationTypes) {
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }
}
