//
//  ARCollectionViewCell.swift
//  Aquarium
//
//  Created by TLPAAdmin on 5/10/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit


protocol QRAnimalCollectionViewDelegate: class {
    func animalFound(_ cell: ARCollectionViewCell)
}

class ARCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var animalNameLabel: UILabel!
    weak var delegate: QRAnimalCollectionViewDelegate?
    
    @IBOutlet weak var animalCheckedButton: UIButton!

    @IBAction func foundAnimal(_ sender: Any) {
        
        delegate?.animalFound(self)
        
    }
    
}
