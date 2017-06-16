//
//  AnimalTestViewController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 6/16/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AnimalTestViewController: UIViewController {
    
    
    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var animalUpdates: UILabel!
    @IBOutlet weak var galleryLabel: UILabel!
    @IBOutlet weak var photoLinkLabel: UILabel!
    @IBOutlet weak var animalDescriptionLabel: UILabel!
    
    
    var animalName = ""
    var animalDescription = ""
    var animalUpdate = ""
    var gallery = ""
    var photoLink = ""
    
    var animals: [AnimalTest] = []

    
    var firebaseReference: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firebaseReference = FIRDatabase.database().reference()
    }

    @IBAction func getAnimalsButtonTapped(_ sender: Any) {
        
        getAnimals()
    }
    
    
    func getAnimals() {
        
        
        let query =  self.firebaseReference.child("Animals")

        query.observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                let animalTest = AnimalTest(snapshot: item as! FIRDataSnapshot)
                self.animals.append(animalTest!)
            }

        })
    }
    
    

    
}
