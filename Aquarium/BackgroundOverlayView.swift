//
//  BackgroundOverlayView.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/15/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import MapKit


class BackgroundOverlayView: MKOverlayRenderer {
    
    
    var overlayImage: UIImage
    var backgroundOverlay = #imageLiteral(resourceName: "background")
    
    init(overlay: MKOverlay, overlayImage: UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
        
        
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        
        
        let image = self.backgroundOverlay
        let mapRect = overlay.boundingMapRect
        let newRect = rect(for: mapRect)
        
        
        UIGraphicsPushContext(context)
        image.draw(in: newRect, blendMode: .normal, alpha: 1.00)
        
        UIGraphicsPopContext()
        
    }
    
    
}
