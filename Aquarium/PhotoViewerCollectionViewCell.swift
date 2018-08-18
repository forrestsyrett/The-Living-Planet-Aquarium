//
//  PhotoViewerCollectionViewCell.swift
//  Aquarium
//
//  Created by Forrest Syrett on 8/5/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import UIKit

class PhotoViewerCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func awakeFromNib() {
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 2.0
        self.scrollView.delegate = self
    }
    
   
    
 
    
    
}
