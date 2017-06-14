//
//  MembershipCardController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 8/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation


class MembershipCardController {
    
    fileprivate let membershipKey = "memberships"
    
    static let sharedMembershipController = MembershipCardController()
    
    var memberships = [MembershipCard]()
    
    init() {
        loadFromPersistentStorage()
    }
    
    
    func addMembership(_ membership: MembershipCard) {
        memberships.append(membership)
        saveToPersistentStorage()
    }
    
    func removeMembership(_ membership: MembershipCard) {
        if let index = memberships.index(of: membership) {
            memberships.remove(at: index)
            saveToPersistentStorage()
        }
    }
    
    func saveToPersistentStorage() {
        
        let membershipDictionaries = self.memberships.map({$0.dictionaryCopy()})
        UserDefaults.standard.set(membershipDictionaries, forKey: membershipKey)
        
    }
    
    func loadFromPersistentStorage() {
        if let membershipDictionariesFromDefaults = UserDefaults.standard.object(forKey: membershipKey) as? [Dictionary<String, AnyObject>] {
            self.memberships = membershipDictionariesFromDefaults.map({MembershipCard(dictionary: $0)!})
        }
    }
}
