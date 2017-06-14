//
//  AnimalFeedTableViewCell.swift
//  Aquarium
//
//  Created by Forrest Syrett on 7/17/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit

protocol AnimalFeedTableViewCellDelegate: class {
    func feedNotificationScheduled(_ animalFeedTableViewCell: AnimalFeedTableViewCell)
}

class AnimalFeedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var animalFeedImage: UIImageView!
    @IBOutlet weak var animalFeedLabel: UILabel!
    @IBOutlet weak var animalFeedTimeLabel: UILabel!
    @IBOutlet weak var notifyMeButtonLabel: UIButton!
    @IBOutlet weak var checkMarkImage: UIImageView!
    weak var delegate: AnimalFeedTableViewCellDelegate?
    
    var notificationScheduled = false {
        didSet {
            notifyMeButtonLabel.setTitle(notificationScheduled ? AnimalFeedTableViewCell.cancelNotification : AnimalFeedTableViewCell.notifyMe, for: UIControlState())
            checkMarkImage.image = UIImage(named: notificationScheduled ? "checkmarkSelected" : "checkmark")
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static let notifyMe = "Notify Me!"
    static let cancelNotification = "Cancel"
    static let IDKey = "ID"
    
    
    fileprivate let sunday = 0
    fileprivate let monday = 1
    fileprivate let tuesday = 2
    fileprivate let wednesday = 3
    fileprivate let thursday = 4
    fileprivate let friday = 5
    fileprivate let saturday = 6
    
    @IBAction func notifyMeButtonTapped(_ sender: AnyObject) {
        notificationScheduled = !notificationScheduled
        
        delegate?.feedNotificationScheduled(self)
    }
    
}


