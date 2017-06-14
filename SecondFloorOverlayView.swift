//
//  SecondFloorOverlayView.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/10/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import MapKit


class SecondFloorOverlayView: MKOverlayRenderer {
    
    
    var overlayImage: UIImage
    var mapOverlay = #imageLiteral(resourceName: "secondFloorFinalRSZ")
    
    init(overlay: MKOverlay, overlayImage: UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
        
        
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        
        
        let image = self.mapOverlay
        let mapRect = overlay.boundingMapRect
        let newRect = rect(for: mapRect)
        
        
        UIGraphicsPushContext(context)
        image.draw(in: newRect, blendMode: .normal, alpha: 1.0)
        
        UIGraphicsPopContext()
        
    }
    
    
}
