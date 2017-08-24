//
//  MapTableViewCell.swift
//  Aquarium
//
//  Created by Forrest Syrett on 3/25/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
   
    
}
