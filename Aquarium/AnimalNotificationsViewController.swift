//
//  AnimalNotificationsViewController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 7/6/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit
import FirebaseStorageUI

class AnimalNotificationsViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updatesImage: UIImageView!
    @IBOutlet weak var updateDescriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var updateIMageHeight: NSLayoutConstraint!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var containerViewYConstraint: NSLayoutConstraint!
    
    var updateInfo = ""
    var imageReference = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatesImage.layer.cornerRadius = 5.0
        containerView.layer.cornerRadius = 5.0
        containerView.clipsToBounds = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.containerView.isHidden = true
        self.containerViewYConstraint.constant = (-self.containerView.frame.height - 30.0)
        dimView.alpha = 0.0
        
        self.updateDescriptionLabel.text = self.updateInfo
        let reference = FIRStorageReference().child(self.imageReference)
        
        if self.imageReference == "" {
            self.updateIMageHeight.constant = 0.0
        } else {
        self.updatesImage.sd_setImage(with: reference)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.containerView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.dimView.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
            self.containerViewYConstraint.constant = 130.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

 
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
            self.containerViewYConstraint.constant = (-self.containerView.frame.height - 30.0)
            self.view.layoutIfNeeded()
        }, completion: { (true) in
            self.dismiss(animated: false, completion: nil)
        })
        
        UIView.animate(withDuration: 0.2) {
            self.dimView.alpha = 0.0
        }

    }

}
