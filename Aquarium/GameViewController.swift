//
//  GameViewController.swift
//  
//
//  Created by TLPAAdmin on 6/4/18.
//

import UIKit
import ARKit
import FlowingMenu


class GameViewController: UIViewController, FlowingMenuDelegate, UIGestureRecognizerDelegate, ARAnimalTableViewControllerDelegate {

    
    
    @IBOutlet weak var sceneView: ARSCNView!

    @IBOutlet weak var buttonsView: UIView!
   
    
    @IBOutlet weak var fishButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var coinsButton: UIButton!
    
    var animalModelName = String()
    var extensionType = String()
    var hasSelectedAnimal: Bool = false
    
    
    
    let flowingMenuTransitionManager = FlowingMenuTransitionManager()
    var menu: UIViewController?
    
    var totalCoinCount: Int = 100
    var fishPrice = 25
    var foodPrice = 10
    var IAPCoins = 100
    
    var selectedAnimalImage = String()
    var selectedAnimalPrice = Int()
    
    var firstBoxCreated: Bool = false
    
    @IBOutlet weak var coinsView: UIView!
    
    @IBOutlet weak var coinLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       roundViews(coinsView, cornerRadius: 5.0)
        roundCornerButtons(fishButton)
        roundCornerButtons(foodButton)
        roundCornerButtons(coinsButton)

        addTapGestureToSceneView()
        
        
      
       
        
        
        // Add the pan screen edge gesture to the current view //
        flowingMenuTransitionManager.setInteractivePresentationView(view)
        
        
        // Add the delegate to respond to interactive transition events
        flowingMenuTransitionManager.delegate = self
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        
        if #available(iOS 11.3, *) {
            configuration.planeDetection = [.vertical, .horizontal]
        } else {
            // Fallback on earlier versions
            configuration.planeDetection = .horizontal
        }
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        sceneView.delegate = self
        sceneView.session.run(configuration)
        
        
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @objc func addShipToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
      
        if hasSelectedAnimal {
        let touchLocation = recognizer.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, types: .featurePoint)
        guard let result = hitTestResult.last else { return }
        
        guard let fishScene = SCNScene(named: animalModelName + extensionType),
            let fishNode = fishScene.rootNode.childNode(withName: animalModelName, recursively: false)
            else { return }
        
        print("Planting trees")
        
        let transform = SCNMatrix4.init(result.worldTransform)
        
        let vector = SCNVector3Make(transform.m41, transform.m42, transform.m43)
        
        
      
        fishNode.position = vector
        sceneView.scene.rootNode.addChildNode(fishNode)
            
        }
       
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameViewController.addShipToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
   

    // Add fish to AR Scene

    @IBAction func fishButtonTapped(_ sender: Any) {
        
        //Check to see if user has enough coins to buy a fish
     /*   if totalCoinCount >= fishPrice {
        totalCoinCount -= fishPrice
        updateCoinLabel()
            addFish(indexPath: 1)
        } else {
        addCoinsAlert()
        }
 */
    }
    
    @IBAction func foodButtonTapped(_ sender: Any) {
        
        // Check to see if user has enough coins to buy food
        if totalCoinCount >= foodPrice {
        totalCoinCount -= 10
        updateCoinLabel()
        } else {
            addCoinsAlert()
        }
    }
    
    @IBAction func coinsButtonTapped(_ sender: Any) {
        
       addCoinsAlert()
       
    }
    
    
    func updateCoinLabel() {
    
        coinLabel.text = "\(totalCoinCount)" + " Coins"
        
    }
    
    func addFish(animalImage: String, animalPrice: Int, index: Int) {
        
        if totalCoinCount >= animalPrice {
//        guard let currentFrame = sceneView.session.currentFrame
//            else { return }
//        var translation = matrix_identity_float4x4
//        translation.columns.3.z = -3.0
//        let transform = currentFrame.camera.transform * translation
     //   self.selectedAnimalImage = animalImage
     //   self.selectedAnimalPrice = animalPrice
     //   totalCoinCount -= animalPrice
     //       updateCoinLabel()
//        let anchor = ARAnchor(transform: transform)
//        sceneView.session.add(anchor: anchor)
            
            hasSelectedAnimal = !hasSelectedAnimal
 
            switch index {
                
            case 0: animalModelName = "tree"
                extensionType = ".dae"
            case 1: animalModelName = "rock"
                extensionType = ".obj"
                
            default: break
                
                
            }

     
  
            
            
            dismiss(animated: true, completion: nil)
        } else{
            dismiss(animated: true, completion: nil)
            addCoinsAlert()
        }
    }
    
    func addCoinsAlert() {
        
        print("Add Coins")
        let alert = UIAlertController(title: "Oops! Not enough coins!", message: "Coins will refill over time, or you can buy more in the shop!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let buyCoinsAction = UIAlertAction(title: "Buy More", style: .default) { (alert) in
            self.addCoins()
        }
        
        alert.addAction(okAction)
        alert.addAction(buyCoinsAction)
        
        self.present(alert, animated: true, completion: nil)
        
    
    }
    func addCoins() {
        
        totalCoinCount += 100
        updateCoinLabel()
    
    }
    
    // Flowing Menu Delegate Functions
    
    func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        performSegue(withIdentifier: "toFishStore", sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        menu?.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toFishStore" {
            let destinationViewController  = segue.destination as! ARAnimalTableViewController
            destinationViewController.transitioningDelegate = flowingMenuTransitionManager
            destinationViewController.delegate = self
            
            // Add the left pan gesture to the  menu
            flowingMenuTransitionManager.setInteractiveDismissView(destinationViewController.view)
            menu = destinationViewController
        }

    }
}
extension GameViewController: ARSKViewDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session Failed - probably due to lack of camera access")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session was interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session resumed")
        sceneView.session.run(session.configuration!, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        let animal = SKSpriteNode(imageNamed: selectedAnimalImage)
        animal.name = selectedAnimalImage
        return animal
    }
    

}

extension GameViewController: ARSCNViewDelegate {

func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    
    /////// Use this to place a plane on a detected surface////////
    
    
    /*
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    
   
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    let plane = SCNPlane(width: width, height: height)
    
    // set plane material
    //plane.materials.first?.diffuse.contents = UIColor.blue
    
    
    let planeNode = SCNNode(geometry: plane)
    
    
    let x = CGFloat(planeAnchor.center.x)
    let y = CGFloat(planeAnchor.center.y)
    let z = CGFloat(planeAnchor.center.z)
    planeNode.position = SCNVector3(x,y,z)
    planeNode.eulerAngles.x = -.pi / 2
    
 
    node.addChildNode(planeNode)
 */
    }
}






