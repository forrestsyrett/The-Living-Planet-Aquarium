//
//  EventTableViewCell.swift
//  Aquarium
//
//  Created by Forrest Syrett on 5/31/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit

protocol EventTableViewCellDelegate: class {
    func eventNotificationScheduled(_ eventTableViewCell: EventTableViewCell)
}



class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    weak var delegate: EventTableViewCellDelegate?

    @IBOutlet weak var notifyMeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func notifyMeButtonTapped(_ sender: Any) {
        
        delegate?.eventNotificationScheduled(self)
    }
    
    
}
