//
//  MainExhibitTableViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/18/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

protocol MainExhibitTableViewControllerDelegate: class {
    func gallerySelected(indexPath: Int)
}

class MainExhibitTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showAllAnimalsButton: UIButton!
    
    
    let mainGalleries = MainExhibitController.shared
    var allGalleries: [MainExhibit] = []
    weak var delegate: MainExhibitTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAllAnimalsButton.layer.cornerRadius = 5.0
        
        allGalleries = [mainGalleries.discoverUtah, mainGalleries.journeyToSouthAmerica, mainGalleries.oceanExplorer, mainGalleries.antarcticAdventure, mainGalleries.expeditionAsia]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "exhibitsAppeared"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allGalleries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExhibitGalleryTableViewCell
        
        let gallery = allGalleries[indexPath.row]
        
        
        cell.galleryNameLabel.text = gallery.exhibitName
        cell.galleryBackgroundImage.image = gallery.exhibitImage
        
        cell.galleryBackgroundImage.layer.cornerRadius = 5.0
        cell.galleryBackgroundImage.clipsToBounds = true
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.gallerySelected(indexPath: indexPath.row)
    }
    
    @IBAction func showAllAnimalsButtonTapped(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "allAnimals"), object: nil)
  
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
