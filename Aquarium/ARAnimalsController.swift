//
//  ARAnimalsController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 6/5/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit

class ARAnimalsController {
    
    
    static let shared = ARAnimalsController()
    
    
    let orangeFish = ARAnimals(name: "Orange Fish", imageString: "OrangeFish", price: 10)
    let koiFish = ARAnimals(name: "Koi Fish", imageString: "KoiFish", price: 30)
    let shark = ARAnimals(name: "Shark", imageString: "Shark", price: 75)
    
    
    
    
}
