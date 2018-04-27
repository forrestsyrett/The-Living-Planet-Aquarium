//
//  AnimalCollectionViewCell.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/22/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

class AnimalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var animalImage: UIImageView!
    var didAnimate = false
    @IBOutlet weak var newsRibbon: UIImageView!
    @IBOutlet weak var newsRibbonHeight: NSLayoutConstraint!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var infoImageHeight: NSLayoutConstraint!
    var time = 0
    
    
}
