//
//  CustomTabBarAnimatedTransition.swift
//  CustomTabBar
//
//  Created by Forrest Syrett on 4/28/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//
//

import UIKit

class CustomTabBarAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    var initialIndex: Int = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) {
            
            let fromView = fromViewController.view
            let toView = toViewController.view
            let containerView = transitionContext.containerView
            
            guard let toIndex = fromViewController.tabBarController?.selectedIndex else { return }
            let fromIndex = IndexController.shared.index
            
            containerView.clipsToBounds = false
            containerView.addSubview(toView!)
            
            // MARK: - Animation Direction
            
            
            
            var fromViewEndFrame = fromView?.frame
            let toViewEndFrame = transitionContext.finalFrame(for: toViewController)
            var toViewStartFrame = toViewEndFrame
            
            if fromIndex > toIndex {
                fromViewEndFrame?.origin.x += (containerView.frame.width)
                toViewStartFrame.origin.x -= (containerView.frame.width)
                toView?.frame = toViewStartFrame
                
            } else if fromIndex < toIndex {
                fromViewEndFrame?.origin.x -= (containerView.frame.width)
                toViewStartFrame.origin.x += (containerView.frame.width)
                toView?.frame = toViewStartFrame
            }
            
            
            
            
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: {
                () -> Void in
                toView?.frame = toViewEndFrame
                fromView?.frame = fromViewEndFrame!
                
            }, completion: { (completed) in
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(completed)
                containerView.clipsToBounds = true
            })
        }
    }
    
}
