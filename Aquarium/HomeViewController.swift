//
//  HomeViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/21/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit
import SafariServices
import CoreLocation
import UserNotifications
import SAConfettiView

class HomeViewController: UIViewController, UITabBarControllerDelegate, UNUserNotificationCenterDelegate, UITabBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var buyTicketsLabel: UIButton!
    @IBOutlet weak var becomeAMemberLabel: UIButton!
    @IBOutlet weak var animalEncountersLabel: UIButton!
    @IBOutlet weak var directionsLabel: UIButton!
    @IBOutlet weak var donateLabel: UIButton!
    @IBOutlet weak var lineOne: UIView!
    @IBOutlet weak var lineTwo: UIView!
    @IBOutlet weak var lineThree: UIView!
    @IBOutlet weak var lineFour: UIView!
    @IBOutlet weak var socialMediaTrayWidth: NSLayoutConstraint!
    @IBOutlet weak var logoButton: UIButton!
    @IBOutlet weak var confettiView: SAConfettiView!
    
    
    var bubbleView = UIImageView()
    
    var destinationName = "String"
    var notificationSwitch = true
    var counter = 0
    
    var time = 0
    var timer = Timer()
    
  //  var tapGesture = UITapGestureRecognizer()
    
    // MARK: - Beacon Regions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tabBarTint(view: self)
        gradient(self.view)
        transparentNavigationBar(self)
        confettiView.isUserInteractionEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateLabel(welcomeLabel, animateTime: 0.5)
        animateLines(lineOne, animateTime: 0.75)
        animateLines(lineTwo, animateTime: 1.0)
        animateLines(lineThree, animateTime: 1.5)
        animateLines(lineFour, animateTime: 2.0)

        
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startBubbles()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
 

    @IBAction func logoButtonTapped(_ sender: Any) {
      
        counter += 1
        
        if counter == 20 {
            if !confettiView.isActive() {
                confettiView.startConfetti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.confettiView.stopConfetti()
            })
        }
        }
        if counter > 20 {
            counter = 0
        }
 
    }
    
    func startBubbles() {
        
            print("start bubbles")
            // time interval controls amount of bubbles generated
            timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(HomeViewController.bubbles), userInfo: nil, repeats: true)
            timer.fire()
        
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        print("tap")
        guard let image = gestureRecognizer.view else { return }
        image.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        image.removeFromSuperview()
        
    }
    
    
    func bubbles() {
   
        let size = randomNumber(low: 10, high: 22)
        let xLocation = randomNumber(low: 8, high: 370)
        
        
        let bubbleImageView = UIImageView(image: UIImage(named: "Bubble"))
        bubbleImageView.frame = CGRect(x: xLocation, y: self.view.frame.height, width: size, height: size)

        view.addSubview(bubbleImageView)
        view.bringSubview(toFront: bubbleImageView)
        
        let zigzagPath = UIBezierPath()
        let originX: CGFloat = xLocation
        // Set bubble starting location to bottom of screen
        let originY: CGFloat = self.view.frame.height
        let eX: CGFloat = originX
        
        // set vertical distance travelled before popping
        let eY: CGFloat = originY - randomNumber(low: Int(self.view.frame.height) - 30, high: Int(self.view.frame.height))
        //t = horizontal displacement
        let t: CGFloat = randomNumber(low: 30, high: 120)
        var startPoint = CGPoint(x: originX - t, y: ((originY + eY) / 2))
        var endPoint = CGPoint(x: originX + t, y: startPoint.y)
        
        let r: Int = Int(arc4random() % 2)
        if r == 1 {
            let temp: CGPoint = startPoint
            startPoint = endPoint
            endPoint = temp
        }
        // the moveToPoint method sets the starting point of the line
        zigzagPath.move(to: CGPoint(x: originX, y: originY))
        // add the end point and the control points
        zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: startPoint, controlPoint2: endPoint)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({() -> Void in
            
            UIView.transition(with: bubbleImageView, duration: 0.1, options: .transitionCrossDissolve, animations: {() -> Void in
                bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {(_ finished: Bool) -> Void in
                bubbleImageView.removeFromSuperview()
            })
        })
   
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 5.2
        pathAnimation.path = zigzagPath.cgPath
        // remains visible in it's final state when animation is finished
        // in conjunction with removedOnCompletion
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        
    //    let viewLocation: CGRect? = bubbleImageView.layer.presentation()?.frame
    //    bubbleImageView.frame = CGRect(x: (viewLocation?.origin.x)!, y: (viewLocation?.origin.y)!, width: (viewLocation?.size.width)!, height: (viewLocation?.size.height)!)
        
        
        CATransaction.commit()
        
    }
    
    
    // MARK: - Notification Code
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let openMemberships = UNNotificationAction(identifier: "openMemberships", title: "Open Membership", options: .foreground)
        let openFeedings = UNNotificationAction(identifier: "openFeedings", title: "Check Feeding Schedule", options: .foreground)
        let category = UNNotificationCategory(identifier: "openTabs", actions: [openMemberships, openFeedings], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    
    func scheduleWelcomeNotification(at date: Date) {
        
        registerCategories()
        
        
        let immediateTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        
        // Notification Content And Identifiers
        let content = UNMutableNotificationContent()
        content.title = "Welcome to the Aquarium!"
        content.body = "Press for more options!"
        
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "openTabs"
        content.userInfo = ["customData": " test"]
        
        // Notification Request
        let request = UNNotificationRequest(identifier: "openMemberships", content: content, trigger: immediateTrigger)
        
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("There was an error \(error)")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
            case "openMemberships":
                // User tapped Open Memberships Button
                print("Show more information…")
                
                let window = UIApplication.shared.delegate?.window
                if window??.rootViewController as? UITabBarController != nil {
                    let tabBarController = window!?.rootViewController as! UITabBarController
                    tabBarController.selectedIndex = 3
                }
            case "openFeedings":
                /// USer tapped open feedings button
                let window = UIApplication.shared.delegate?.window
                if window??.rootViewController as? UITabBarController != nil {
                    let tabBarController = window!?.rootViewController as! UITabBarController
                    tabBarController.selectedIndex = 1
                }
                break
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    
    
    // MARK: Social Media Actions
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        UIApplication.tryURL(urls: [
            "fb://profile/138949625025", // App
            "http://www.facebook.com/138949625025" //Website
            ])
    }
    
    @IBAction func instagramButtonTapped(_ sender: Any) {
        UIApplication.tryURL(urls: [
            "instagram://user?username=lovelandlivingplanet", // App
            "http://www.instagram.com/lovelandlivingplanet" //Website
            ])
    }
     
    @IBAction func twitterButtonTapped(_ sender: Any) {
        UIApplication.tryURL(urls: [
            "twitter://user?screen_name=livingplanetUT", // App
            "http://www.twitter.com/livingplanetUT" //Website
            ])
    }
    
    ////////////////
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if segue.identifier == "buyTickets" {
            
            let destination = segue.destination as! HomeWebViewController
            destination.buttonHidden = true
            destination.titleLabelString = "Tickets"
            destination.requestString = "https://tickets.thelivingplanet.com/WebStore/Shop/ViewItems.aspx?CG=online&C=Tickets"
        }
        if segue.identifier == "animalEncounters" {
            
            let destination = segue.destination as! HomeWebViewController
            destination.buttonHidden = true
            destination.titleLabelString = "Encounters"
            destination.requestString = "http://thelivingplanet.com/animalencounters/"
        }
        if segue.identifier == "donate" {
            
            let destination = segue.destination as! HomeWebViewController
            destination.buttonHidden = true
            destination.titleLabelString = "Help Us Grow"
            destination.requestString = "http://www.thelivingplanet.com/home-4/give/"
        }
    }

    
    
}
