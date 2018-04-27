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

func randomNumber(low: Int, high: Int) -> CGFloat {
    let random = CGFloat(arc4random_uniform(UInt32(high)) + UInt32(low))
    return random
}


func bubbles(view: UIView) {
  
    let size = randomNumber(low: 8, high: 15)
    print("SIZE: \(size)")
    let xLocation = randomNumber(low: 19, high: 31)
    print("X LOCATION: \(xLocation)")
    
    let bubbleImageView = UIImageView(image: UIImage(named: "Bubble"))
    bubbleImageView.frame = CGRect(x: xLocation, y: view.center.y + 50, width: size, height: size)
    view.addSubview(bubbleImageView)
    view.bringSubview(toFront: bubbleImageView)
    
    let zigzagPath = UIBezierPath()
    let oX: CGFloat = xLocation
    let oY: CGFloat = view.center.y + 20
    let eX: CGFloat = oX
    let eY: CGFloat = oY - randomNumber(low: 50, high: 30)
    let t: CGFloat = randomNumber(low: 20, high: 100)
    var cp1 = CGPoint(x: oX - t, y: ((oY + eY) / 2))
    var cp2 = CGPoint(x: oX + t, y: cp1.y)
    
    let r: Int = Int(arc4random() % 2)
    if r == 1 {
        let temp: CGPoint = cp1
        cp1 = cp2
        cp2 = temp
    }
    // the moveToPoint method sets the starting point of the line
    zigzagPath.move(to: CGPoint(x: oX, y: oY))
    // add the end point and the control points
    zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
    
    CATransaction.begin()
    CATransaction.setCompletionBlock({() -> Void in
        
        UIView.transition(with: bubbleImageView, duration: 0.1, options: .transitionCrossDissolve, animations: {() -> Void in
            bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: {(_ finished: Bool) -> Void in
            bubbleImageView.removeFromSuperview()
        })
    })
    
    let pathAnimation = CAKeyframeAnimation(keyPath: "position")
    pathAnimation.duration = 1.5
    pathAnimation.path = zigzagPath.cgPath
    // remains visible in it's final state when animation is finished
    // in conjunction with removedOnCompletion
    pathAnimation.fillMode = kCAFillModeForwards
    pathAnimation.isRemovedOnCompletion = false
    bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
    
    CATransaction.commit()
    
}

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


