//
//  OpeningScreenViewController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 2/22/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class OpeningScreenViewController: UIViewController {
    
    
    @IBOutlet weak var welcomeToLabel: UILabel!
    @IBOutlet weak var livingplanetLabel: UILabel!
    
    @IBOutlet weak var beginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateLabel(self.welcomeToLabel, animateTime: 0.8)
        animateLabel(self.livingplanetLabel, animateTime: 1.3)
        animateButton(self.beginButton, animateTime: 1.8)
        
        self.view.backgroundColor = .black
        
        let bundleUrl = Bundle.main.path(forResource: "jellies", ofType: "MOV")
        let url = NSURL(fileURLWithPath: bundleUrl!)
        let player = AVPlayer(url: url as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        player.isMuted = true
        self.view.layer.insertSublayer(playerLayer, at: 0)
        
        player.play()
        
        loopVideo(videoPlayer: player)
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        
        self.beginButton.layer.borderWidth = 1.0
        self.beginButton.layer.borderColor = UIColor.white.cgColor
        roundCornerButtons(self.beginButton)
        
    }
    
    @IBAction func beginButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "begin", sender: self)
        
        
    }
    
    
    
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: kCMTimeZero)
            videoPlayer.play()
        }
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

