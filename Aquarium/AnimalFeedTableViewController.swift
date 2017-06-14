//
//  AnimalFeedTableViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 7/17/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit
import OneSignal

class AnimalFeedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AnimalFeedTableViewCellDelegate, UIGestureRecognizerDelegate {
    
    
    static let shared = AnimalFeedTableViewController()
    
    @IBOutlet weak var animalFeedTableView: UITableView!
    @IBOutlet weak var weekdaySegmentedControl: UISegmentedControl!
    @IBOutlet var rightSwipeGesture: UISwipeGestureRecognizer!
    
    
    var selectedWeekday: Int {
        return weekdaySegmentedControl.selectedSegmentIndex + 1
    }
    
    
    fileprivate let reuseIdentifier = "feedCell"
    
    var notificationController = NotificationController()
    var feeds = [Feeding]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        
        gradient(self.view)
        animalFeedTableView.backgroundColor = UIColor.clear
        weekdaySegmentedControl.tintColor = UIColor.white
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(AnimalFeedTableViewController.handleLeftSwipes))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(AnimalFeedTableViewController.handleRightSwipes))
        
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(rightSwipe)
        
        tabBarTint(view: self)
        
        
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.weekday], from: date)
        let dayOfWeek = components.weekday! - 1
        
        weekdaySegmentedControl.selectedSegmentIndex = dayOfWeek
        
        if dayOfWeek == 0 {
            feeds = [.shark, .penguin]
        }
        else if dayOfWeek == 1 {
            feeds = [.archerfish, .penguin]
        }
        else if dayOfWeek == 2 {
            feeds = [.piranha, .shark, .riverGiant, .penguin]
        }
        else if dayOfWeek == 3 {
            feeds = [.penguin]
        }
        else if dayOfWeek == 4 {
            feeds = [.piranha, .shark, .archerfish, .riverGiant, .penguin]
        }
        else if dayOfWeek == 5 {
            feeds = [.penguin]
        }
        else if dayOfWeek == 6 {
            feeds = [.shark, .archerfish, .riverGiant, .penguin]
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animalFeedTableView.reloadData()
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
        
    }
    
    
    
    func handleLeftSwipes(sender:UISwipeGestureRecognizer) {
        /*
         let selectedIndex: Int = self.weekdaySegmentedControl.selectedSegmentIndex
         
         if weekdaySegmentedControl.selectedSegmentIndex >= 6 { return }
         
         
         self.weekdaySegmentedControl.selectedSegmentIndex = selectedIndex + 1
         let dayOfWeek = weekdaySegmentedControl.selectedSegmentIndex
         
         
         if dayOfWeek == 0 {
         feeds = [.shark, .penguin]
         }
         else if dayOfWeek == 1 {
         feeds = [.archerfish, .penguin]
         }
         else if dayOfWeek == 2 {
         feeds = [.piranha, .shark, .riverGiant, .penguin]
         }
         else if dayOfWeek == 3 {
         feeds = [.penguin]
         }
         else if dayOfWeek == 4 {
         feeds = [.piranha, .shark, .archerfish, .riverGiant, .penguin]
         }
         else if dayOfWeek == 5 {
         feeds = [.penguin]
         }
         else if dayOfWeek == 6 {
         feeds = [.shark, .archerfish, .riverGiant, .penguin]
         }
         animalFeedTableView.reloadData()
         */
    }
    
    func handleRightSwipes(sender:UISwipeGestureRecognizer) {
        /*
         let selectedIndex: Int = self.weekdaySegmentedControl.selectedSegmentIndex
         
         if weekdaySegmentedControl.selectedSegmentIndex <= 0 { return }
         
         self.weekdaySegmentedControl.selectedSegmentIndex = selectedIndex - 1
         let dayOfWeek = weekdaySegmentedControl.selectedSegmentIndex
         
         
         if dayOfWeek == 0 {
         feeds = [.shark, .penguin]
         }
         else if dayOfWeek == 1 {
         feeds = [.archerfish, .penguin]
         }
         else if dayOfWeek == 2 {
         feeds = [.piranha, .shark, .riverGiant, .penguin]
         }
         else if dayOfWeek == 3 {
         feeds = [.penguin]
         }
         else if dayOfWeek == 4 {
         feeds = [.piranha, .shark, .archerfish, .riverGiant, .penguin]
         }
         else if dayOfWeek == 5 {
         feeds = [.penguin]
         }
         else if dayOfWeek == 6 {
         feeds = [.shark, .archerfish, .riverGiant, .penguin]
         }
         animalFeedTableView.reloadData()
         */
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
        
        print(weekdaySegmentedControl.selectedSegmentIndex)
        animalFeedTableView.reloadData()
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feeds.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AnimalFeedTableViewCell
        
        cell.delegate = self
        
        let feed = feeds[(indexPath as NSIndexPath).row]
        cell.animalFeedLabel.text = feed.info.animalName
        cell.animalFeedImage.image = feed.info.image
        cell.animalFeedTimeLabel.text = feed.info.timeString
        cell.backgroundColor = UIColor.clear
        cell.notificationScheduled = notificationCheck(feed.info.animalName, weekday: selectedWeekday)
        /*
         cell.animalFeedImage.alpha = 0.0
         cell.animalFeedLabel.alpha = 0.0
         cell.animalFeedTimeLabel.alpha = 0.0
         cell.checkMarkImage.alpha = 0.0
         cell.notifyMeButtonLabel.alpha = 0.0
         
         
         animateLabel(cell.animalFeedLabel, animateTime: 0.75)
         animateImage(cell.animalFeedImage, animateTime: 0.75)
         animateLabel(cell.animalFeedTimeLabel, animateTime: 0.75)
         animateImage(cell.checkMarkImage, animateTime: 0.75)
         animateButton(cell.notifyMeButtonLabel, animateTime: 0.75)
         */
        
        roundCornerButtons(cell.notifyMeButtonLabel)
        roundCornerButtons(cell.animalFeedImage)
        
        
        // Slide cells into view
        func animate(_ cellView: UIView) {
            
            view.addSubview(cellView)
            let basicAnimation = CABasicAnimation()
            basicAnimation.keyPath = "position.x"
            basicAnimation.fromValue = cellView.center.x + 350
            basicAnimation.toValue = cellView.center.x + -30
            basicAnimation.duration = 0.35
            cellView.layer.add(basicAnimation, forKey: "slide")
            cellView.center.x += -30
        }
        
        animate(cell)
        
        return cell
    }
    
    
    // check notifications to see which are scheduled
    // animal name in code below = Animal.Info.AnimalName
    
    func notificationCheck(_ animalName: String, weekday: Int) -> Bool {
        guard let scheduledLocalNotifications = UIApplication.shared.scheduledLocalNotifications else { return false }
        var found = false
        for notification in scheduledLocalNotifications {
            guard let userInfo = notification.userInfo as? [String: String] else { return false }
            if userInfo[String(weekday)] == animalName {
                found = true
            }
        }
        return found
    }
    
    @IBAction func weekdaySegmentedControlSelected(_ sender: AnyObject) {
        feeds = Feeding.feeding(on: selectedWeekday)
        animalFeedTableView.reloadData()
        
    }
    
    //MARK: - AnimalFeedTableViewCellDelegate Methods
    
    
    func feedNotificationScheduled(_ animalFeedTableViewCell: AnimalFeedTableViewCell) {
        
        print("Delegate Heard")
        guard let indexPath = animalFeedTableView.indexPath(for: animalFeedTableViewCell) else { return }
        let feed = feeds[(indexPath as NSIndexPath).row]
        
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types:
            [.alert, .badge, .sound], categories: nil))
        
        notificationController.scheduleNotification(for: feed, onWeekday: selectedWeekday, scheduled: animalFeedTableViewCell.notificationScheduled)
        
    }
    
    // Clears all notifications
    @IBAction func clearFeedingsButtonTapped(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Clear Notifications?", message: "This will cancel all scheduled feeding notifications", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Clear", style: .default) { (action) in
            UIApplication.shared.cancelAllLocalNotifications()
            self.animalFeedTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    
}





