//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Forrest Syrett on 4/28/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit
import Foundation

protocol CustomTabBarDataSource {
    func tabBarItemsInCustomTabBar(_ tabBarView: CustomTabBar) -> [UITabBarItem]
}

protocol CustomTabBarDelegate {
    func didSelectViewController(_ tabBarView: CustomTabBar, atIndex index: Int)
}

class CustomTabBar: UIView {
    
    static let shared = CustomTabBar()
    
    var datasource: CustomTabBarDataSource!
    var delegate: CustomTabBarDelegate!
    var tabBarItems: [UITabBarItem]!
    var customTabBarItems: [CustomTabBarItem]!
    var tabBarButtons: [UIButton]!
    var initialTabBarItemIndex: Int!
    
    var selectedTabBarItemIndex: Int!
    var slideAnimationDuration: Double!
    var slideMaskDelay: Double!
    
    
    var tabBarItemWidth: CGFloat!
    var leftMask: UIView!
    var rightMask: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = aquaWaveColor
     //   self.layer.borderWidth = 0.5
     //   self.layer.borderColor = UIColor.white.cgColor
        
        
                self.clipsToBounds = true
        //        let rightBorder = CALayer()
        //        rightBorder.borderColor = UIColor.white.cgColor
        //        rightBorder.borderWidth = 0.5
        //        rightBorder.frame = CGRect(x: CGFloat(-1), y: CGFloat(-1), width: CGFloat(self.frame.width), height: CGFloat(self.frame.height + 2))
        //        self.layer.addSublayer(rightBorder)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        // get tab bar items from default tab bar
        tabBarItems = datasource.tabBarItemsInCustomTabBar(self)
        
        initialTabBarItemIndex = IndexController.shared.initialTabBarIndex
        selectedTabBarItemIndex = initialTabBarItemIndex
        
        slideAnimationDuration = 0.3
        slideMaskDelay = slideAnimationDuration / 2
        
        customTabBarItems = []
        tabBarButtons = []
        
        let containers = createTabBarItemContainers()
        createTabBarItemSelectionOverlay(containers: containers)
        createItemSelectionOverlayMask(containers: containers)
        createTabBarItems(containers)
    }
    
    // MARK: Tab Bar Button Properties
    func createTabBarItemSelectionOverlay(containers: [CGRect]) {
        
        
        
       let overlayColors = [aquaDark, aquaDark, aquaLight, aquaDark, aquaDark]
        
      //  let overlayColors = [aquaLight, aquaLight, aquaDark, aquaLight, aquaLight]
        
        
        for index in 0..<tabBarItems.count {
            let container = containers[index]
            
            let view = UIView(frame: container)
            
            let selectedItemOverlay = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            selectedItemOverlay.backgroundColor = overlayColors[index]
            let blurView = UIVisualEffectView()
            view.addSubview(blurView)
            view.addSubview(selectedItemOverlay)
            self.addSubview(view)
        }
    }
    
    
    // MARK: Overlay Colors
    func createItemSelectionOverlayMask(containers: [CGRect]) {
        
        tabBarItemWidth = self.frame.width / CGFloat(tabBarItems.count)
        let leftOverlaySlidingMultiplier = CGFloat(initialTabBarItemIndex) * tabBarItemWidth
        let rightOverlaySlidingMultiplier = CGFloat(initialTabBarItemIndex + 1) * tabBarItemWidth
        
        leftMask = UIView(frame: CGRect(x: 0, y: 0, width: leftOverlaySlidingMultiplier, height: self.frame.height))
        leftMask.backgroundColor = aquaLight
        rightMask = UIView(frame: CGRect(x: rightOverlaySlidingMultiplier, y: 0, width: tabBarItemWidth * CGFloat(tabBarItems.count - 1), height: self.frame.height))
        rightMask.backgroundColor = aquaLight
        
        self.addSubview(leftMask)
        self.addSubview(rightMask)
    }
    
    
    func animateTabBarSelection(from: Int, to: Int) {
        
        let overlaySlidingMultiplier = CGFloat(to - from) * tabBarItemWidth
        
        let leftMaskDelay: Double
        let rightMaskDelay: Double
        
        if overlaySlidingMultiplier > 0 {
            leftMaskDelay = slideMaskDelay
            rightMaskDelay = 0
        }
        else {
            leftMaskDelay = 0
            rightMaskDelay = slideMaskDelay
        }
        
        
        UIView.animate(withDuration: slideAnimationDuration - leftMaskDelay, delay: leftMaskDelay, options: .curveEaseInOut, animations: {
            self.leftMask.frame.size.width += overlaySlidingMultiplier
        }, completion: nil)
        
        UIView.animate(withDuration: slideAnimationDuration - rightMaskDelay, delay: rightMaskDelay, options: .curveEaseInOut, animations: {
            self.rightMask.frame.origin.x += overlaySlidingMultiplier
            self.rightMask.frame.size.width += -overlaySlidingMultiplier
            self.customTabBarItems[from].iconView.tintColor = UIColor.white
            self.customTabBarItems[to].iconView.tintColor = UIColor.white
        }, completion: nil)
    }
    
    
    
    func createTabBarItems(_ containers: [CGRect]) {
        
        var index = 0
        for item in tabBarItems {
            
            
            let container = containers[index]
            
            let customTabBarItem = CustomTabBarItem(frame: container)
            customTabBarItem.setup(item)
            
            self.addSubview(customTabBarItem)
            customTabBarItems.append(customTabBarItem)
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: container.width, height: container.height))
            button.addTarget(self, action: #selector(CustomTabBar.barItemTapped(_:)), for: UIControlEvents.touchUpInside)
            
            customTabBarItem.addSubview(button)
            tabBarButtons.append(button)
         
            index += 1
        }
        
        self.customTabBarItems[initialTabBarItemIndex].iconView.tintColor = UIColor.white
    }
    
    func createTabBarItemContainers() -> [CGRect] {
        
        var containerArray = [CGRect]()
        
        // create container for each tab bar item
        for index in 0..<tabBarItems.count {
            let tabBarContainer = createTabBarContainer(index)
            containerArray.append(tabBarContainer)
        }
        
        return containerArray
    }
    
    func createTabBarContainer(_ index: Int) -> CGRect {
        
        let tabBarContainerWidth = self.frame.width / CGFloat(tabBarItems.count)
        let tabBarContainerRect = CGRect(x: tabBarContainerWidth * CGFloat(index), y: 0, width: tabBarContainerWidth, height: self.frame.height)
        
        return tabBarContainerRect
    }
    
    @objc func barItemTapped(_ sender : UIButton) {
        let index = tabBarButtons.index(of: sender)!
        
        animateTabBarSelection(from: selectedTabBarItemIndex, to: index)
        selectedTabBarItemIndex = index        
        delegate.didSelectViewController(self, atIndex: index)
    }
}
