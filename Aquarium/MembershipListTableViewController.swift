//
//  MembershipCardTableViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 8/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import UserNotifications

class MembershipListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var membershipCardTableView: UITableView!
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var addAMembershipButton: UIButton!
    @IBOutlet weak var plusButton: UIBarButtonItem!
    @IBOutlet weak var becomeAMemberButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient(self.view)
        tabBarTint(view: self)
        membershipCardTableView.backgroundColor = UIColor.clear
        transparentNavigationBar(self)
        membershipCardTableView.reloadData()
        roundCornerButtons(becomeAMemberButtonLabel)
        roundCornerButtons(welcomeView)
        roundCornerButtons(blurView)
        roundCornerButtons(addAMembershipButton)
        addAMembershipButton.layer.borderColor = UIColor.white.cgColor
        addAMembershipButton.layer.borderWidth = 1.0
        addAMembershipButton.backgroundColor = aquaLight
        
        NotificationCenter.default.addObserver(self, selector: #selector(MembershipListTableViewController.reloadView), name: Notification.Name(rawValue: "addedNewMembership"), object: nil)
        
        self.membershipCardTableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
        
  
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        membershipCardTableView.reloadData()
        
        
        if MembershipCardController.sharedMembershipController.memberships.count != 0 {
            welcomeView.isHidden = true
            blurView.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(MembershipListTableViewController.addMembership))
        } else {
            welcomeView.isHidden = false
            blurView.isHidden = false
            self.navigationItem.rightBarButtonItem = nil
        }
        if self.tabBarController == nil {
            print("tabBar is not loaded yet")
        } else {
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
        }
        
        
        
    }
    
    
    @objc func addMembership() {
        
        self.performSegue(withIdentifier: "addMembership", sender: nil)
    }
    
    
    
    @objc func reloadView() {
        self.membershipCardTableView.reloadData()
        welcomeView.isHidden = true
        self.blurView.isHidden = true
    }
    
    
    @IBAction func becomeAMemberButtonTapped(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "becomeAMember", sender: nil)
        
    }
    
    
    let membership = MembershipCardTableViewCell()
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MembershipCardController.sharedMembershipController.memberships.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! MembershipCardTableViewCell
        
        let membership = MembershipCardController.sharedMembershipController.memberships[(indexPath as NSIndexPath).row]
        
        
        func barcodefromString(_ string : String) -> UIImage? {
            
            guard let barcode = string.data(using: String.Encoding.ascii) else { return barcodefromString("1") }
            let filter = CIFilter(name: "CICode128BarcodeGenerator")
            filter!.setValue(barcode, forKey: "inputMessage")
            return UIImage(ciImage: filter!.outputImage!)
        }
        
        // Configure the cell...
        cell.firstNameLabel.isHidden = true
        cell.lastNameLabel.isHidden = true
        cell.fullNameLabel.text = "\(membership.firstName) \(membership.lastName)"
        cell.membershipIDLabel.text = membership.memberID
        cell.barcodeImage.image = barcodefromString(membership.memberID)
        
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        
        cell.expirationDateLabel.text = "Expires: \((dateFormat.string(from: membership.expirationDate)))"
        cell.backgroundColor = UIColor.clear
        roundCornerButtons(cell.barcodeImage)
        
        return cell
    }
    
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let membership = MembershipCardController.sharedMembershipController.memberships[(indexPath as NSIndexPath).row]
            
            MembershipCardController.sharedMembershipController.removeMembership(membership)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            reloadView()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "addedNewMembership"), object: nil)
        print("removed Notification")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "becomeAMember" {
            
            let destination = segue.destination as! HomeWebViewController
            destination.titleLabelString = "Memberships"
            destination.requestString = "https://tickets.thelivingplanet.com/WebStore/Shop/ViewItems.aspx?CG=online&C=Memberships"
        }

    }
    
}






