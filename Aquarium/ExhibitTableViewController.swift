//
//  ExhibitTableViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/11/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

class ExhibitTableViewController: UIViewController, UITableViewDataSource  {
    
    
    @IBOutlet weak var animalTableView: UITableView!
    @IBOutlet weak var exhibitGalleryLabel: UILabel!
    
    
    var exhibitAnimals = [Animals]()
    var exhibitGalleryLabelMutable = "Exhibit Gallery"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient(self.view)
        exhibitGalleryLabel.text = exhibitGalleryLabelMutable
        animalTableView.reloadData()
        animalTableView.rowHeight = UITableViewAutomaticDimension
        animalTableView.estimatedRowHeight = 400
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animalTableView.reloadData()
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
        return exhibitAnimals.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as! AnimalTableViewCell
        
        // Configure the cell...
        
        let animal = exhibitAnimals[(indexPath as NSIndexPath).row]
        cell.animalNameLabel.text = animal.info.name
        cell.animalPreviewImage.image = animal.info.animalImage
        cell.backgroundColor = cell.contentView.backgroundColor
        roundCornerButtons(cell.animalPreviewImage)
        
        return cell
        
    }
    @IBAction func dismiss(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}


extension ExhibitTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? AnimalTableViewCell else { return }
        
        let animal = exhibitAnimals[(indexPath as NSIndexPath).row]
        
        exhibitAnimals[(indexPath as NSIndexPath).row] = animal
        
        cell.moreInfoTextField?.text = animal.info.description
        
        UIView.animate(withDuration: 0.4, animations: {
            cell.contentView.layoutIfNeeded()
        }) 
        
        animalTableView.beginUpdates()
        animalTableView.endUpdates()
        
        animalTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let moreInfoText = "Tap to learn more! >"
        guard let cell = tableView.cellForRow(at: indexPath) as? AnimalTableViewCell else { return }
        
        let animal = exhibitAnimals[(indexPath as NSIndexPath).row]
        
        exhibitAnimals[(indexPath as NSIndexPath).row] = animal
        
        cell.moreInfoTextField.text = moreInfoText
        
        UIView.animate(withDuration: 0.4, animations: {
            cell.contentView.layoutIfNeeded()
        }) 
        
        animalTableView.beginUpdates()
        animalTableView.endUpdates()
    }
    
    
    
}
