//
//  MenuCollectionViewCell.swift
//  Aquarium
//
//  Created by Forrest Syrett on 7/29/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 2.0
        self.scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.menuImage
    }
}
