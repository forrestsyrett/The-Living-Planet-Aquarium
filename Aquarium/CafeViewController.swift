//
//  CafeViewController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 5/31/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import UIKit
import WebKit

class CafeViewController: UIViewController {

    @IBOutlet weak var WebView: WKWebView!
    @IBOutlet weak var dismissButton: UIButton!
    
    var request: URLRequest = URLRequest(url: URL(string: "http://reefcafe.mobilebytes.com")!)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
