//
//  UIAppearance.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/11/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit

let aquaDarker = UIColor(red: 0, green: 0.3176, blue: 0.4863, alpha: 1.0)
let aquaDark = UIColor(red:0.00, green:0.35, blue:0.53, alpha:1.00)
let aquaMedium = UIColor(red: 0.1451, green: 0.6235, blue: 0.7686, alpha: 1.0)
let aquaLight = UIColor(red:0.13, green:0.43, blue:0.60, alpha:1.00)
let lightBlue = UIColor(red:0.27, green:0.60, blue:0.80, alpha:1.00)


let aquaWaveColor = UIColor(red:0.20, green:0.36, blue:0.53, alpha:1.00)
let aquaLightTransparent = UIColor(red:0.13, green:0.43, blue:0.60, alpha:0.85)


func gradient (_ view: UIView) {
    
    
    let gradientLayer = CAGradientLayer()
    
    view.backgroundColor = UIColor(red: 0, green: 0.3961, blue: 0.8196, alpha: 1.0)
    gradientLayer.frame = view.bounds
    let color1 = UIColor(red: 0, green: 0.3961, blue: 0.8196, alpha: 1.0).cgColor as CGColor
    let color2 = UIColor(red: 0.05, green: 0.16, blue: 0.24, alpha: 1.0).cgColor as CGColor
    let color3 = UIColor(red: 0.149, green: 0.4392, blue: 0.498, alpha: 1.0).cgColor as CGColor
    
    
    //    gradientLayer.colors = [color1, color3, color2]
    gradientLayer.colors = [aquaLight.cgColor as CGColor, aquaMedium.cgColor as CGColor, aquaDark.cgColor as CGColor]
    
    gradientLayer.locations = [0.0, 0.50, 0.8]
    
    view.layer.insertSublayer(gradientLayer, at: 0)
    
    
}

func bottomSheetGradient (_ view: UIView) {
    
    
    let gradientLayer = CAGradientLayer()
    
    view.backgroundColor = UIColor(red: 0, green: 0.3961, blue: 0.8196, alpha: 1.0)
    gradientLayer.frame = view.bounds
    
    
    gradientLayer.colors = [lightBlue.cgColor as CGColor, aquaLight.cgColor as CGColor, aquaMedium.cgColor as CGColor, aquaDark.cgColor as CGColor]
    
    gradientLayer.locations = [0.0, 0.30, 0.50, 0.8]
    
    view.layer.insertSublayer(gradientLayer, at: 0)
    
    
}

func transparentNavigationBar(_ viewController: UIViewController) {
    
    viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    viewController.navigationController?.navigationBar.shadowImage = UIImage()
    viewController.navigationController?.navigationBar.isTranslucent = true
    viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    viewController.navigationController?.navigationBar.tintColor = UIColor.white
    
}

func roundCornerButtons(_ view: UIView) {
    view.layer.cornerRadius = 5
    view.layer.masksToBounds = true
}
func roundViews(_ view: UIView, cornerRadius: CGFloat) {
    view.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
    view.layer.cornerRadius = cornerRadius * view.bounds.size.width
    view.clipsToBounds = false
}

func roundedCorners(_ view: UIView, cornerRadius: CGFloat) {
    
    view.layer.cornerRadius = cornerRadius
    view.clipsToBounds = true
}

func shadow(_ view: UIView) {
    
    view.layer.shadowOpacity = 0.8
    view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    view.layer.shadowRadius = 10.0
    view.layer.shadowColor = UIColor.white.cgColor
    
}

func glow(view: UIView) {
    
    view.layer.borderColor = UIColor.white.cgColor
    view.layer.borderWidth = 1.0
    view.layer.shadowColor = UIColor.white.cgColor
    view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    view.layer.shadowOpacity = 0.8
    view.layer.shadowRadius = 5.0
}

func tabBarTint(view: UIViewController) {
    view.tabBarController?.tabBar.barTintColor = UIColor(red:0.00, green:0.10, blue:0.20, alpha:1.00)
}

