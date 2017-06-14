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
    var image = ""
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
        
        let weekday = getWeekday(date: Date())
        let notificationScheduled = AnimalFeedTableViewController.shared.notificationCheck("Shark Feed", weekday: weekday)
        
        if notificationScheduled {
            self.button.setTitle("Shark Feed Notification Scheduled!", for: .normal)
        } else {
            self.button.setTitle(self.buttonLabel, for: .normal)
        }
    }
    
    
    // Updates current view from previous preapreForSegueMethod
    func updateWithInfo() {
        self.galleryTitleLabel.text = self.titleLabel
        self.galleryInfo.text = self.info
        self.galleryImage.image = UIImage(named: self.image)
        
    }
    
    // Gets the Int number for the current weekday
    func getWeekday(date: Date) -> Int {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.weekday], from: date)
        let dayOfWeek = components.weekday!
        
        return dayOfWeek
    }
    
    
    
    // Near shark beacon, allows user to schedule a notification for the shark feed. Code checks for existing notification so they don't double schedule the same notification.
    
    func scheduleSharkFeed() {
        
        let weekday = getWeekday(date: Date())
        
        
        let notificationScheduled = AnimalFeedTableViewController.shared.notificationCheck("Shark Feed", weekday: weekday)
        
        
        
        if notificationScheduled == false {
            NotificationController().scheduleNotification(for: .shark, onWeekday: weekday, scheduled: true)
            
            let alert = UIAlertController(title: "Shark Feed Notification Scheduled!", message: "We'll alert you 15 minutes before the shark feeding.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Awesome!", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
            self.button.setTitle("Shark Feed Notification Scheduled!", for: .normal)
            
        } else {
            
            let alert = UIAlertController(title: "Cancel Notification?", message: "Would you like to cancel your notification for the shark feeding?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                
                NotificationController().scheduleNotification(for: .shark, onWeekday: weekday, scheduled: false)
                self.button.setTitle("Notify me about the Shark Feeding!", for: .normal)
            })
            let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
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
            scheduleSharkFeed()
        }
    }
    
}
