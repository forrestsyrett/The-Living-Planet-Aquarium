//
//  Animations.swift
//  Aquarium
//
//  Created by Forrest Syrett on 7/14/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit



// ANIMATIONS

func animateImage(_ image: UIImageView, animateTime: Double) {
    image.alpha = 0.0
    UIView.animate(withDuration: animateTime, animations: {
        image.alpha = 1.0
    })
}

func animateButton(_ image: UIButton, animateTime: Double) {
    image.alpha = 0.0
    UIView.animate(withDuration: animateTime, animations: {
        image.alpha = 1.0
    })
}

func animateLabel(_ label: UILabel, animateTime: Double) {
    label.alpha = 0.0
    UILabel.animate(withDuration: animateTime, animations: {
        label.alpha = 1.0
    })
}


// Use UIVIEW to animate all views in cell

func animateLines(_ view: UIView, animateTime: Double) {
    view.alpha = 0.0
    UIView.animate(withDuration: animateTime, animations: {
        view.alpha = 1.0
    })
}


// Button - Touch Down and Up animations //

func buttonBounceTouchDown(_ view: UIView) {
    
    let scaleTransform = CGAffineTransform(scaleX: 0.93, y: 0.93)
    
    UIView.animate(withDuration: 1.5,
                   delay: 0.0,
                   usingSpringWithDamping: 0.35,
                   initialSpringVelocity: 6.0,
                   options: .allowUserInteraction,
                   animations: { view.transform = scaleTransform } ,
                   completion: nil)
}

func buttonBounceTouchUp(_ view: UIView) {
    
    let scaleTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    
    UIView.animate(withDuration: 1.5,
                   delay: 0.0,
                   usingSpringWithDamping: 0.35,
                   initialSpringVelocity: 6.0,
                   options: .allowUserInteraction,
                   animations: { view.transform = scaleTransform } ,
                   completion: nil)
}


