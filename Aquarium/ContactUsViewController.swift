//
//  ContactUsViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 8/12/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var mapsButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gradient(self.view)
        roundCornerButtons(mapsButton)
        roundCornerButtons(phoneNumberButton)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func phoneNumberButton(_ sender: AnyObject) {
        
        let callAlert = UIAlertController(title: "Call the Living Planet Aquarium?", message: "801-355-3474", preferredStyle: .alert)
        let callAction = UIAlertAction(title: "Call", style: .default) { (callAlert) in
            UIApplication.shared.open(URL(string: "tel://8013553474")!, options: [:], completionHandler: nil)
        }
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        callAlert.addAction(callAction)
        callAlert.addAction(cancelAlert)
        
        self.present(callAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func openInMapsButtonTapped(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Open in Maps?", message: "12033 Lone Peak Parkway, Draper UT", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            UIApplication.shared.openURL(URL(string: "http://maps.apple.com/?q=Loveland+Living+Planet+Aquarium")!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            return }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
