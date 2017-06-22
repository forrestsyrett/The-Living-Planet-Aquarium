//
//  AnimalTest.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/16/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class AnimalTest: FIRDataSnapshot {
    
    
    
    var animalName: String?
    var animalInfo: String?
    var animalUpdates: String?
    var conservationStatus: String?
    var gallery: String?
    var animalImage: String?
    var factSheet: String?
    
    init?(snapshot: FIRDataSnapshot) {
        guard let snap = snapshot.value as? [String: Any],
        let animalName = snap["name"] as? String,
        let animalInfo = snap["info"] as? String,
        let animalUpdates = snap["updates"] as? String,
        let conservationStatus = snap["conservationStatus"] as? String,
        let gallery = snap["gallery"] as? String,
        let animalImage = snap["imageLink"] as? String,
        let factSheet = snap["factSheet"] as? String else { return nil }
        
        self.animalName = animalName
        self.animalInfo = animalInfo
        self.animalUpdates = animalUpdates
        self.conservationStatus = conservationStatus
        self.gallery = gallery
        self.animalImage = animalImage
        self.factSheet = factSheet

}


}
