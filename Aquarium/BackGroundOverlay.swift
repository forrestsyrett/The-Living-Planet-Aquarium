//
//  BackGroundOverlay.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/14/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import MapKit

class BackGroundOverlay: NSObject, MKOverlay {
    
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    
    init(background: Background) {
        boundingMapRect = background.overlayBoundingMapRect
        coordinate = background.midCoordinate
    }

}
