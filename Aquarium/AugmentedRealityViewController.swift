//
//  AugmentedRealityViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 5/2/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//



import UIKit



class AugmentedRealityViewController: UIViewController, CraftARContentEventsProtocol, CraftARSDKProtocol, SearchProtocol, CraftARTrackingEventsProtocol, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var videoPreview: UIView!
    
    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var aquaWave: UIImageView!
    
    var sdk = CraftARSDK()
    var craftARTracking: CraftARTracking!
    var cloudRecognition = CraftARCloudRecognition()
    var allARItems: [CraftARItem] = []
    
    @IBOutlet weak var arAnimalView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelBlur: UIVisualEffectView!
    
    @IBOutlet weak var ARCollectionView: UICollectionView!
    
    @IBOutlet weak var arAnimalViewYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var availableScans: UILabel!
    
    
    var totalScans = 5
    var ARViewIsVisible = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.sdk = CraftARSDK.shared()
        self.sdk.delegate = self
        
        
        self.cloudRecognition = CraftARCloudRecognition.sharedCloudImage()
        self.cloudRecognition.delegate = self
        
        self.craftARTracking = CraftARTracking.shared()
        self.craftARTracking.delegate = self
        
        self.scanButton.layer.cornerRadius = 15.0
        aquaWave.alpha = 0.9
        scanButton.backgroundColor = aquaLight
        cancelBlur.clipsToBounds = true
        cancelBlur.layer.cornerRadius = 5.0
        self.availableScans.text = "\(self.totalScans)"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        sdk.startCapture(with: self.videoPreview)
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
        self.arAnimalViewYConstraint.constant = UIScreen.main.bounds.height - UIScreen.main.bounds.height - self.arAnimalView.frame.height

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        sdk.stopCapture()
        craftARTracking.removeAllARItems()
    }
    
    
    
    func didStartCapture() {
        
        self.sdk.searchControllerDelegate = self.cloudRecognition.mSearchController
        
        
        // Collection token defined on CraftAR Creator
        self.cloudRecognition.setCollectionWithToken("9a555febd00d4813", onSuccess: { () -> Void in
            print("ready to search!")
            
//            self.searchForObjects()
            
        }) { (error) -> Void in
            print("Error setting token: \(error?.localizedDescription ?? "No Error")")
        }
    }
    
    
    func searchForObjects() {
        
        //Start searching for recognizable objects
        self.sdk.startFinder()
        print("Finder Started")
    }
    
    
    
    
    func didGetSearchResults(_ results: [Any]) {
        
        var haveARItems: Bool = false
        var haveIRItems: Bool = false
        if results.count >= 1 {
            sdk.stopFinder()
            print("Got search result. Stopped Finder")
            
            //Found one result. Only showing AR Content for the item at index[0]
            // change this to loop through the array for each image for multiple scans
            
            let result = results[0]
            
            //Cast "Any" result to CraftARSearchResult to access .item property
            let newResult = result as! CraftARSearchResult
            
            // Each result has one item
            let item: CraftARItem = newResult.item
            if (item is CraftARItemAR) {
                let arItem: CraftARItemAR = (item as! CraftARItemAR)
                print("THIS IS THE ITEM \(arItem)")
                print("\(arItem.allContents())")
                
                self.cloudRecognition.embedCustomField = true
                
                //Add recognized item to Tracking array
                let err: Error? = craftARTracking.addARItem(arItem)
                
                if err != nil {
                    print("Error adding AR item: \(err?.localizedDescription ?? "No Error")")
                }
                haveARItems = true
            }
            
            if haveARItems {
                CraftARTracking.shared().delegate = self
                //Start AR experience
                self.craftARTracking.start()
                
                print("STARTING OBJECT TRACKING")
                
                
                // Following Code for Image Recognition Only
            } else if haveARItems == false && results.count >= 1 {
                print("found item but no AR scene")
                sdk.stopFinder()
                print(item.name)
                presentAlert(item: item)
                
            }
                
                //////////////////////////////////////
            else {
                sdk.startFinder()
                print("HIT ELSE STATEMENT")
            }
        }
        else {
            sdk.stopFinder()
            self.scanButton.setTitle("Scan!", for: .normal)
            print("No item found. Limiting scan to button pressed.")
            
            // MARK: - No Item Found Notification
            // ADD ALERT FOR NO ITEM FOUND HERE
        }
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        
        if scanButton.titleLabel?.text == "Scan!" {
            
            sdk.startFinder()
            self.craftARTracking.removeAllARItems()
            self.scanButton.setTitle("Scanning...", for: .normal)
            
            print("Finder Started")
            
            
        }
            
        else {
            
            
            self.scanButton.setTitle("Scan!", for: .normal)
            
            sdk.stopFinder()
            craftARTracking.stop()
            print("Finder Stopped")
            
        }
    }
    
    
    func presentAlert(item: CraftARItem) {
        
        if let name = item.name {
            let alert = UIAlertController(title: "You've found the \(name)!", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Awesome!", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            self.sdk.stopFinder()
            self.scanButton.setTitle("Scan!", for: .normal)
            
        }
    }
    
    
    
    func didFailSearchWithError(_ error: Error!) {
        sdk.stopFinder()
        print("Search Failed")
        self.scanButton.setTitle("Scan!", for: .normal)
    }
    
    
    
    func didStartTrackingItem(_ item: CraftARItemAR!) {
        print("Tracking started for: \(item.name)")
        
    }
    
    func didStopTrackingItem(_ item: CraftARItemAR!) {
        print("Tracking stopped for: \(item.name)")
    }
    
    
    func didGet(_ event: CraftARContentTouchEvent, for content: CraftARTrackingContent) {
        switch event {
            
        case .CRAFTAR_CONTENT_TOUCH_IN:
            print("Touch in: \(content.uuid)")
            
            
        case .CRAFTAR_CONTENT_TOUCH_OUT:
            print("Touch out: \(content.uuid)")
            
            
        case .CRAFTAR_CONTENT_TOUCH_UP:
            print("Touch up: \(content.uuid)")
            //Show animal facts here when object is tapped
            
            
        case .CRAFTAR_CONTENT_TOUCH_DOWN:
            print("Touch down: \(content.uuid)")
            
        }
        
    }
    
    // MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return AnimalController.shared.allAnimals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ARCollectionViewCell
        
        let animal = AnimalController.shared.allAnimals[indexPath.row]
        
        cell.animalImage.image = animal.info.animalImage
        cell.animalNameLabel.text = animal.info.name
        cell.clipsToBounds = true
            cell.layer.cornerRadius = 5.0
        cell.animalImage.layer.cornerRadius = 5.0
        cell.animalNameLabel.layer.cornerRadius = 5.0
        
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
    
    if segue.identifier == "toAnimalDetail" {
    
    if let destinationViewController = segue.destination as? AnimalDetailViewController {
    
    let indexPath = self.ARCollectionView.indexPath(for: (sender as! UICollectionViewCell))
        
    if let selectedItem = (indexPath as NSIndexPath?)?.row {
   
    let animal = AnimalController.shared.allAnimals[selectedItem]
    print(selectedItem)
    destinationViewController.updateInfo(animal: animal)
    destinationViewController.animal = animal.info.name
            }
        }
    }
}
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
    
        animateDown()
    }
    
    
    @IBAction func TestScanButtonTapped(_ sender: Any) {
        if self.totalScans > 0 && self.ARViewIsVisible == false {
       animateUp()
            self.totalScans -= 1
            self.availableScans.text = "\(self.totalScans)"
        } else if self.totalScans == 0 {
            let alert = UIAlertController(title: "You're out of scans!", message: "Would you like to purchase some more?", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let buyMoreAction = UIAlertAction(title: "Buy More", style: .default, handler: { (action) in
                self.totalScans = 5
                self.availableScans.text = "\(self.totalScans)"
            })
            alert.addAction(dismissAction)
            alert.addAction(buyMoreAction)
            self.present(alert, animated: true, completion: nil)
        }
        else { return }
    }
    
    
    func animateUp() {
        
          self.arAnimalViewYConstraint.constant = UIScreen.main.bounds.height - UIScreen.main.bounds.height + 55
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
            self.scanButton.alpha = 0.0
        }, completion: nil)
        self.ARViewIsVisible = true
    }
    
    
    func animateDown() {
         self.arAnimalViewYConstraint.constant = UIScreen.main.bounds.height - UIScreen.main.bounds.height - self.arAnimalView.frame.height
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
            self.scanButton.alpha = 1.0
        }, completion: nil)
        self.ARViewIsVisible = false
        
    }
    
    
}
