//
//  SceneKitViewController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 3/21/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit
import SceneKit
import SceneKit.ModelIO

class SceneKitViewController: UIViewController {
    
    
    @IBOutlet weak var sceneView: SCNView!
    
    
    var geometryNode: SCNNode = SCNNode()
    
    var currentAngle: Float = 0.0
    
    var materials = [SCNMaterial]()
    
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient(self.view)
        dismissButton.layer.cornerRadius = 19.5
        dismissButton.clipsToBounds = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sceneSetup()
    }
    
    
    func sceneSetup() {
        
        let scene = SCNScene()
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "shark", ofType: "obj")
        let url = NSURL(fileURLWithPath: path!)
        let asset = MDLAsset(url: url as URL)
        let object = asset.object(at: 0) as? MDLMesh
        
        
        
        // Apply texture to SCN Object
        let scatteringFunction = MDLScatteringFunction()
        let mdlMaterial = MDLMaterial(name: "sharkTexture.jpg", scatteringFunction: scatteringFunction)
        
        mdlMaterial.setTextureProperties(textures: [.baseColor: "sharkTexture.jpg"])
        
        for  submesh in (object?.submeshes!)!  {
            if let submesh = submesh as? MDLSubmesh {
                submesh.material = mdlMaterial
            }
        }
        
        
        
        
        
        let node =  SCNNode(mdlObject: object!)
        
        
        scene.rootNode.addChildNode(node)
        
        
        let ambientLightingNode = SCNNode()
        ambientLightingNode.light = SCNLight()
        ambientLightingNode.light!.type = .ambient
        ambientLightingNode.light!.color = UIColor.init(white: 0.67, alpha: 1.0)
        // scene.rootNode.addChildNode(ambientLightingNode)
        
        
        
        let omniLightingNode = SCNNode()
        omniLightingNode.light = SCNLight()
        omniLightingNode.light!.type = .omni
        omniLightingNode.light!.color = UIColor.init(white: 0.75, alpha: 1.0)
        omniLightingNode.position = SCNVector3Make(0, 50, 50)
        // scene.rootNode.addChildNode(omniLightingNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 25)
        //  scene.rootNode.addChildNode(cameraNode)
        
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(SceneKitViewController.panGesture(sender:)))
        sceneView.addGestureRecognizer(panGesture)
        
        
        sceneView.scene = scene
        
        
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        
        
    }
    
    
    // Whenever sceneView detects a pan gesture, this function will be called, and it transforms the gesture’s x-axis translation to a y-axis rotation on the geometry node (1 pixel = 1 degree).
    
    func panGesture(sender: UIPanGestureRecognizer) {
        let translaton = sender.translation(in: sender.view!)
        var newAngle = (Float)(translaton.x)*(Float)(M_PI)/180.0
        newAngle += currentAngle
        
        geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
        
        if(sender.state == UIGestureRecognizerState.ended) {
            currentAngle = newAngle
        }
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
}

extension MDLMaterial {
    
    func setTextureProperties(textures: [MDLMaterialSemantic: String]) -> Void {
        for (key, value) in textures {
            guard let url = Bundle.main.url(forResource: value, withExtension: "") else {
                fatalError("Failed to find URL for resource \(value).")
            }
            
            let property = MDLMaterialProperty(name: value, semantic: key, url: url)
            self.setProperty(property)
        }
    }
}
