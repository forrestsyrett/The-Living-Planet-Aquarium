//
//  TheaterTimesTableViewCell.swift
//  Aquarium
//
//  Created by TLPAAdmin on 4/13/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit

class TheaterTimesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var showTimesLabel: UILabel!
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
