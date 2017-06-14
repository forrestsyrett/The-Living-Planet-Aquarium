//
//  AnnotationViews.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import MapKit


class AnnotationViews: MKAnnotationView {
    
    
    
    //    let newFrame = CGRect.zero
    //
    //     init(frame: CGRect) {
    //        super.init(frame: self.newFrame)
    //
    //    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let exhibitAnnotation = self.annotation as! Annotation
        switch (exhibitAnnotation.type) {
            
        case .Utah:
            image = #imageLiteral(resourceName: "transparent")
        case .Jsa:
            image = #imageLiteral(resourceName: "transparent")
        case .Giftshop:
            image = #imageLiteral(resourceName: "transparent")
        case .Oceans:
            image = #imageLiteral(resourceName: "transparent")
        case .Asia:
            image = #imageLiteral(resourceName: "transparent")
        case .Tukis:
            image = #imageLiteral(resourceName: "transparent")
        case .AntarcticAdventure:
            image = #imageLiteral(resourceName: "transparent")
        case .Banquet:
            image = #imageLiteral(resourceName: "transparent")
        case .Bathrooms:
            image = #imageLiteral(resourceName: "transparent")
        case .Jellies:
            image = #imageLiteral(resourceName: "transparent")
        case .Elevator:
            image = #imageLiteral(resourceName: "transparent")
        case .DeepSeaLab:
            image = #imageLiteral(resourceName: "transparent")
        case .CurrentLocation:
            image = #imageLiteral(resourceName: "mapArrow")
        case .Theater:
            image = #imageLiteral(resourceName: "transparent")
        case .EducationCenter:
            image = #imageLiteral(resourceName: "transparent")
        case .MothersRoom:
            image = #imageLiteral(resourceName: "transparent")
        case .Cafe:
            image = #imageLiteral(resourceName: "transparent")
        }
    }
    
    
    
}
