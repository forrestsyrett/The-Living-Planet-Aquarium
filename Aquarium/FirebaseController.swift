//
//  FirebaseController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/16/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseController {
    
    
    static let sharedController = FirebaseController()
    
    var databaseReference: FIRDatabaseReference
    
    init() {
        self.databaseReference = FIRDatabase.database().reference()
    }
    
}

protocol FirebaseType {
    var identifier: String? { get set }
    var endpoint: String { get }
    var jsonValue: [String: AnyObject] { get }
    
    init?(dictionary: [String: AnyObject], identifier: String)
    
    mutating func save()
    func delete()
}

extension FirebaseType {
    mutating func save() {
        var reference = FirebaseController.sharedController.databaseReference.child(self.endpoint)
        
        if let identifier = self.identifier {
            reference = reference.child(identifier)
        } else {
            reference = reference.childByAutoId()
            self.identifier = reference.key
        }
        reference.updateChildValues(self.jsonValue)
    }
    
    func delete() {
        if let identifier = identifier {
            let reference = FirebaseController.sharedController.databaseReference.child(self.endpoint).child(identifier)
            reference.removeValue()
        }
    }
}

