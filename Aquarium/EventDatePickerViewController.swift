//
//  EventDatePickerViewController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 7/8/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit

class EventDatePickerViewController: UIViewController {

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkEventsButton: UIButton!
    
    
    
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 6, to: Date())
        
        datePicker.tintColor = UIColor.white
        datePicker.setValue(UIColor.white, forKey: "textColor")
        checkEventsButton.layer.cornerRadius = 5.0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       getDate()
        dimView.alpha = 0.0
        self.containerView.isHidden = true
        self.containerViewYConstraint.constant = (-self.containerView.frame.height - 30)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.containerView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.dimView.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
            self.containerViewYConstraint.constant = self.view.frame.height / 6
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    @IBAction func dateChanged(_ sender: Any) {
        getDate()
    }
    
    

    @IBAction func checkEventsButtonTaped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "unwindToEvents", sender: nil)
    }
    
    
    func getDate() {
        self.date = datePicker.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: date)
        
        self.eventTitleLabel.text = "Check events for \(dateString)"
    }
    
    

    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
            self.containerViewYConstraint.constant = (-self.containerView.frame.height - 30)
            self.view.layoutIfNeeded()
        }, completion: { (true) in
            self.dismiss(animated: false, completion: nil)
        })
        
        UIView.animate(withDuration: 0.2) {
            self.dimView.alpha = 0.0
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindToEvents" {
            
            if let destination = segue.destination as? EventsViewController {
                destination.unwindDate = self.date
            }
        }
    }

}
