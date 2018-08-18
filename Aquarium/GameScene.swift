//
//  GameScene.swift
//  Aquarium
//
//  Created by TLPAAdmin on 6/4/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import ARKit


class GameScene: SKScene {
    
    var sceneView: ARSKView {
        
        return view as! ARSKView
    }
    
    var isWorldSetup = false
    
    private func setupWorld() {
        
     
        
        isWorldSetup = true
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !isWorldSetup {
            setupWorld()
        }
    }
    
    
    

}
