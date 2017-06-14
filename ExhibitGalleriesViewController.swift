//
//  ExhibitGalleriesViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/11/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//
//

/*
import Foundation
import UIKit


protocol ExhibitGalleriesViewControllerDelegate: class {
    func discoverUtahButtonTapped(_ exhibitGalleriesViewController: ExhibitGalleriesViewController)
}

class ExhibitGalleriesViewController: UIViewController, UITabBarDelegate {
    

    static let sharedController = ExhibitGalleriesViewController()
    
    
    
    // MARK: Outlets
    @IBOutlet weak var discoverUtahButton: UIButton!
    @IBOutlet weak var oceanExplorerButton: UIButton!
    @IBOutlet weak var journeyToSouthAmericaButton: UIButton!
    @IBOutlet weak var antarcticAdventureButton: UIButton!
    @IBOutlet weak var expeditionAsiaButton: UIButton!
    weak var delegate: ExhibitGalleriesViewControllerDelegate?
    

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        tabBarTint(view: self)
        
        roundCornerButtons(discoverUtahButton)
        roundCornerButtons(oceanExplorerButton)
        roundCornerButtons(journeyToSouthAmericaButton)
        roundCornerButtons(antarcticAdventureButton)
        roundCornerButtons(expeditionAsiaButton)
        transparentNavigationBar(self)
    }
    

    

    @IBAction func discoverUtahButtonTapped(_ sender: AnyObject) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "discoverUtah"), object: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let exhibitAnimalViewController = segue.destination as? ExhibitTableViewController
        
            if (segue.identifier == "discoverUtah") {
            exhibitAnimalViewController?.exhibitAnimals = [Animals.otters, .tortoise]
            exhibitAnimalViewController?.exhibitGalleryLabelMutable = "Discover Utah"
        }
            else if (segue.identifier == "journeyToSouthAmerica") {
                exhibitAnimalViewController?.exhibitAnimals = [Animals.arapaima, .toucan]
                exhibitAnimalViewController?.exhibitGalleryLabelMutable = "Journey To South America"
        }
            else if (segue.identifier == "antarcticAdventure") {
                exhibitAnimalViewController?.exhibitAnimals = [Animals.penguins]
                exhibitAnimalViewController?.exhibitGalleryLabelMutable = "Antarctic Adventure"
        }
            else if (segue.identifier == "oceanExplorer") {
                exhibitAnimalViewController?.exhibitAnimals = [Animals.greenSeaTurtle, .eel, .zebraShark]
                exhibitAnimalViewController?.exhibitGalleryLabelMutable = "Ocean Explorer"
        }
            else if (segue.identifier == "expeditionAsia") {
                exhibitAnimalViewController?.exhibitAnimals = [Animals.binturong, .cloudedLeopards, .hornbill]
                exhibitAnimalViewController?.exhibitGalleryLabelMutable = "Expedition Asia"
        }
    }
}
*/
