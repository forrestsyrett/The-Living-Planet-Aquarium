//
//  DeviceCheck.swift
//  Aquarium
//
//  Created by Forrest Syrett on 4/25/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit


class DeviceCheck {
    
    static let shared = DeviceCheck()
    var device: String = ""
    
    func checkDevice() {
    if UIDevice().userInterfaceIdiom == .phone {
    switch UIScreen.main.nativeBounds.height {
    case 1136:
    device = "iPhone 5"
    case 1334:
    device = "iPhone 6/6S/7/8"
    case 1920, 2208:
    device = "iPhone 6+/6S+/7+/8+"
    case 2436:
    device = "iPhone X"
    default:
    print("unknown")
    }
    }
    }
    
    
    
    
    
}
