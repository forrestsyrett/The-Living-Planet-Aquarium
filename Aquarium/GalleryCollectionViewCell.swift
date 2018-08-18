//
//  GalleryCollectionViewCell.swift
//  Aquarium
//
//  Created by TLPAAdmin on 8/1/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    var didAnimate = false
    
}
