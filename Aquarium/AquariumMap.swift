//
//  AquariumMap.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import MapKit

class AquariumMap {
    
    var boundary: [CLLocationCoordinate2D]
    var boundaryPointsCount: NSInteger
    
    var midCoordinate: CLLocationCoordinate2D
    var topLeftMapCoordinate: CLLocationCoordinate2D
    var topRightMapCoordinate: CLLocationCoordinate2D
    var bottomLeftMapCoordinate: CLLocationCoordinate2D
    var bottomRightMapCoordinate: CLLocationCoordinate2D {
        
        get {
            let coordinate = CLLocationCoordinate2DMake(bottomLeftMapCoordinate.latitude, topRightMapCoordinate.longitude)
            return coordinate
        }
    }
    
    var overlayBoundingMapRect: MKMapRect {
        get {
            
            let topLeft = MKMapPointForCoordinate(topLeftMapCoordinate)
            let topRight = MKMapPointForCoordinate(topRightMapCoordinate)
            let bottomLeft = MKMapPointForCoordinate(bottomLeftMapCoordinate)
            
            return MKMapRectMake(topLeft.x, topLeft.y, fabs(topLeft.x - topRight.x), fabs(topLeft.y - bottomLeft.y))
        }
    }
    
    var name: String?
    
    
    init(filename: String) {
        let filePath = Bundle.main.path(forResource: filename, ofType: "plist")
        let properties = NSDictionary(contentsOfFile: filePath!)
        
        let midPoint = CGPointFromString(properties!["midCoord"] as! String)
        midCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(midPoint.x), CLLocationDegrees(midPoint.y))
        
        let overlayTopLeftPoint = CGPointFromString(properties!["overlayTopLeftCoord"] as! String)
        topLeftMapCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(overlayTopLeftPoint.x), CLLocationDegrees(overlayTopLeftPoint.y))
        
        let overlayTopRightPoint = CGPointFromString(properties!["overlayTopRightCoord"] as! String)
        topRightMapCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(overlayTopRightPoint.x), CLLocationDegrees(overlayTopRightPoint.y))
        
        let overlayBottomLeftPoint = CGPointFromString(properties!["overlayBottomLeftCoord"] as! String)
        bottomLeftMapCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(overlayBottomLeftPoint.x), CLLocationDegrees(overlayBottomLeftPoint.y))
        
        let boundaryPoints = properties!["boundary"] as! NSArray
        
        boundaryPointsCount = boundaryPoints.count
        
        boundary = []
        
        for i in 0...boundaryPointsCount - 1 {
            let p = CGPointFromString(boundaryPoints[i] as! String)
            boundary += [CLLocationCoordinate2DMake(CLLocationDegrees(p.x), CLLocationDegrees(p.y))]
            
        }
    }
}
