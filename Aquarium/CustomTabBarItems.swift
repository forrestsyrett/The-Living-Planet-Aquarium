//
//  CustomTabBarItems.swift
//  CustomTabBar
//
//  Created by Forrest Syrett on 4/28/17.
//  Copyright © 2017 Swift Joureny. All rights reserved.
//

import UIKit

class CustomTabBarItem: UIView {
    
    var iconView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(_ item: UITabBarItem) {
        
        guard let image = item.image else {
            fatalError("Add images to tabBar items")
        }
        
        
        iconView = UIImageView(frame: CGRect(x: (self.frame.width-image.size.width)/2, y: (self.frame.height-image.size
            .height)/2, width: self.frame.width, height: self.frame.height))
        iconView.image = image
        iconView.sizeToFit()
        iconView.tintColor = UIColor.white
        
        self.addSubview(iconView)
    }
    
    
}
