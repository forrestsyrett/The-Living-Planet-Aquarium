//
//  BeaconInfoViewController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 12/6/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

class BeaconInfoViewController: UIViewController {
    
    @IBOutlet weak var galleryTitleLabel: UILabel!
    @IBOutlet weak var galleryInfo: UILabel!
    @IBOutlet weak var galleryImage: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var titleLabel = ""
    var info = ""
    var image = UIImage()
    var buttonLabel = ""
    var segueIdentifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient(self.view)
        roundedCorners(self.galleryImage, cornerRadius: 5.0)
        roundedCorners(self.button, cornerRadius: 5.0)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateWithInfo()
        
    }
    
    
    // Updates current view from previous preapreForSegueMethod
    func updateWithInfo() {
        self.galleryTitleLabel.text = self.titleLabel
        self.galleryInfo.text = self.info
        self.galleryImage.image = self.image
        
    }
    

    func scheduleSharkFeed() {

    
    }
    
    
    
    // Button animations
    
    @IBAction func buttonTouchDown(_ sender: Any) {
        
        buttonBounceTouchDown(self.button)
    }
    
    @IBAction func buttonTouchDragExit(_ sender: Any) {
        
        buttonBounceTouchUp(self.button)
    }
    
    @IBAction func buttonTouchDragEnter(_ sender: Any) {
        
        buttonBounceTouchDown(self.button)
    }
    
    @IBAction func buttonTouchUpInside(_ sender: Any) {
        
        buttonBounceTouchUp(self.button)
        
        if self.segueIdentifier == "penguinEncounter" {
            
            self.performSegue(withIdentifier: self.segueIdentifier, sender: sender)
        }
        
        if self.segueIdentifier == "sharks" {

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "penguinEncounter" {
            let destination = segue.destination as! AnimalEncountersViewController
                destination.requestString = "http://thelivingplanet.com/animalencounters/"
            destination.titleLabelString = "Encounters"
            
        }
        
        
    }
    
    
    
    
}
