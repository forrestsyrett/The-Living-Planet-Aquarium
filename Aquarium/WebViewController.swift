//
//  WebViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/9/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedCorners(self.dismissButton, cornerRadius: 26.8)
        
        let url = URL(string: "http://www.thelivingplanet.com/essential_grid_category/invertebrates/")!
        self.webView.loadRequest(URLRequest(url: url))
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        buttonBounceTouchUp(self.dismissButton)
    }
    @IBAction func touchDown(_ sender: Any) {
        buttonBounceTouchDown(self.dismissButton)
    }
    @IBAction func touchDragExit(_ sender: Any) {
        buttonBounceTouchUp(self.dismissButton)
    }
    @IBAction func touchDragEnter(_ sender: Any) {
        buttonBounceTouchDown(self.dismissButton)
    }
    
    
    
}
