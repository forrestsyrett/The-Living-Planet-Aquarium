//
//  AnimalEncountersViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/22/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

class AnimalEncountersViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var requestString = ""
    var titleLabelString = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        gradient(self.view)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        transparentNavigationBar(self)
        
        webView.scrollView.bounces = false
        webView.scalesPageToFit = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        webView.loadRequest(URLRequest(url: URL(string: requestString)!))
        
        self.titleLabel.text = titleLabelString
        
    }
    
    
       /* @IBAction func bookYourEncounterButtonTapped(_ sender: Any) {
     buttonBounceTouchUp(self.encounterButton)
     
     let callAlert = UIAlertController(title: "Call the Living Planet Aquarium?", message: "801-355-3474", preferredStyle: .alert)
     let callAction = UIAlertAction(title: "Call", style: .default) { (callAlert) in
     UIApplication.shared.openURL(URL(string: "tel://8013553474")!)
     }
     let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
     callAlert.addAction(callAction)
     callAlert.addAction(cancelAlert)
     
     self.present(callAlert, animated: true, completion: nil)
     }
     
     
     @IBAction func encounterButtonTouchDragExit(_ sender: Any) {
     buttonBounceTouchUp(self.encounterButton)
     }
     @IBAction func encounterButtonTouchDragEnter(_ sender: Any) {
     buttonBounceTouchDown(self.encounterButton)
     }
     @IBAction func encounterButtonTouchDown(_ sender: Any) {
     buttonBounceTouchDown(self.encounterButton)
     }
     
     
     /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
     */
}
