//
//  ExhibitGalleryTableViewCell.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/18/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

class ExhibitGalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var galleryBackgroundImage: UIImageView!
    @IBOutlet weak var galleryNameLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
