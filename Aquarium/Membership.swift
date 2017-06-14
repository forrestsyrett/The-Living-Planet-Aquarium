//
//  Membership.swift
//  Aquarium
//
//  Created by Forrest Syrett on 8/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit


class MembershipCard: Equatable {
    
    
    fileprivate var firstNameKey = "firstName"
    fileprivate var lastNameKey = "lastName"
    fileprivate var memberIDNumberKey = "memberID"
    fileprivate var barcodeImageKey = "barcodeImage"
    fileprivate var expirationDateKey = "date"
    
    
    var memberID: String
    var firstName: String
    var lastName: String
    var barcodeImageString: String
    var expirationDate: Date
    
    
    init(memberID: String, firstName: String, lastName: String, barcodeImageString: String, expirationDate: Date) {
        
        self.memberID = memberID
        self.firstName = firstName
        self.lastName = lastName
        self.barcodeImageString = barcodeImageString
        self.expirationDate = expirationDate
        
    }
    init?(dictionary: Dictionary<String, AnyObject>) {
        guard let memberID = dictionary[memberIDNumberKey],
            let firstName = dictionary[firstNameKey],
            let lastName = dictionary[lastNameKey],
            let barcodeImage = dictionary[barcodeImageKey],
            let expirationDate = dictionary[expirationDateKey]
            else {
                self.barcodeImageKey = ""
                self.firstNameKey = ""
                self.lastNameKey = ""
                self.memberID = ""
                self.expirationDate = Date(timeInterval: 1.0, since: Date())
                return nil
        }
        
        self.memberID = memberID as! String
        self.firstName = firstName as! String
        self.lastName = lastName as! String
        self.barcodeImageString = barcodeImage as! String
        self.expirationDate = expirationDate as! Date
        
    }
    
    func dictionaryCopy() -> Dictionary<String, AnyObject> {
        let dictionary = [
            memberIDNumberKey: memberID.self,
            firstNameKey: firstName.self,
            lastNameKey: lastName.self,
            barcodeImageKey: barcodeImageString.self,
            expirationDateKey: expirationDate.self] as [String : Any]
        
        return dictionary as Dictionary<String, AnyObject>
    }
    
    
    
}

func ==(lhs: MembershipCard , rhs: MembershipCard ) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    
}
