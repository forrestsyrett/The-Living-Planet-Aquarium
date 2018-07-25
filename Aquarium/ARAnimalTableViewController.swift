//
//  ARAnimalTableViewController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 6/4/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import UIKit
import FlowingMenu

protocol ARAnimalTableViewControllerDelegate: class {
    func addFish(animalImage: String, animalPrice: Int, index: Int)
}

class ARAnimalTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FlowingMenuDelegate {
    
    
    var availableAnimals: [ARAnimals] = []
    var animalController = ARAnimalsController.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    
    weak var delegate: ARAnimalTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.delegate = self
        
        
        availableAnimals = [animalController.orangeFish, animalController.koiFish, animalController.shark]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return availableAnimals.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ARAnimalTableViewCell

        
        let animal = availableAnimals[indexPath.row]
        
        
        cell.animalNameLabel.text = animal.name
        cell.animalImage.image = UIImage(named: animal.imageString)!
        cell.priceLabel.text = "\(animal.price)" + " Coins"
        
        cell.animalImage.layer.cornerRadius = 5.0
        cell.animalImage.clipsToBounds = true

        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let animal = availableAnimals[indexPath.row]
        delegate?.addFish(animalImage: animal.imageString, animalPrice: animal.price, index: indexPath.row)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
