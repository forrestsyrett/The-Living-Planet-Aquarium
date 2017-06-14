//
//  MembershipCardTableViewCell.swift
//  Aquarium
//
//  Created by Forrest Syrett on 8/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

class MembershipCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var barcodeImage: UIImageView!
    @IBOutlet weak var membershipIDLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        
    }
    
}
