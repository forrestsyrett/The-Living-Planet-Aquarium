//
//  AnimalTableViewCell.swift
//  Aquarium
//
//  Created by Forrest Syrett on 7/14/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var animalPreviewImage: UIImageView!
    @IBOutlet weak var moreInfoTextField: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
