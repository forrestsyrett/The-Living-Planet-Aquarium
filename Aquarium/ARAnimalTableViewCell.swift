//
//  ARAnimalTableViewCell.swift
//  Aquarium
//
//  Created by TLPAAdmin on 6/4/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import UIKit

class ARAnimalTableViewCell: UITableViewCell {

    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var animalImage: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
  
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
