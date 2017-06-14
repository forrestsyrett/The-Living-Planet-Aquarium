//
//  AquariumMapOverlay.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class AquariumMapOverlay: NSObject, MKOverlay {
    
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    
    init(aquarium: AquariumMap) {
        boundingMapRect = aquarium.overlayBoundingMapRect
        coordinate = aquarium.midCoordinate
    }
}
