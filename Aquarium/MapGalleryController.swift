//
//  MapGalleryController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit

class MapGalleryController {
    
    static let sharedController = MapGalleryController()
    
    let oceanExplorer = MapGalleries(name: "Ocean Explorer", image1: #imageLiteral(resourceName: "oceans"), info: "1. Stingray Touch Pool\n2. Giant Pacific Octopus\n3. 40' Shark Tunnel\n4. 300,000 Gallon Shark Tank")
    let antarcticAdventure = MapGalleries(name: "Antarctic Adventure", image1: #imageLiteral(resourceName: "penguins"), info: "5. NOAA Research Vessel\n6. Sea Jellies\n7. Deep Sea Lab\n8. Gentoo Penguins")
    let discoverUtah = MapGalleries(name: "Discover Utah", image1: #imageLiteral(resourceName: "utah"), info: "9.   Desert Tortoise\n10. Fish of Utah\n11. River Otters")
    let jsa = MapGalleries(name: "Journey to South America", image1: #imageLiteral(resourceName: "jsa"), info: "12. Electric Eel\n13. Dwarf Caiman\n14. Green Anaconda\n15. River Giants\n16. Toucans (second floor)\n17. Poison Dart Frogs (second floor)")
    let expeditionAsia = MapGalleries(name: "Expedition: Asia", image1: #imageLiteral(resourceName: "asia"), info: "18. Clouded Leopards\n19. Small-Clawed Otters\n20. Binturongs")
    let tukis = MapGalleries(name: "Tuki's Island Play & Party Center", image1: #imageLiteral(resourceName: "tukis"), info: "22. Play Area (ages 3-12)\n- Two-story playground\n- Motion Sensor Games\n- Toddler Area\n- Free Entry with Aquarium Membership\n- General Admission ages 3-12 ($3.00)\n23. Birthday Party Rooms\n- 4 Private birthday party rooms\n- Each party includes admissions for up to 20 guests\n- Pizza and drinks included\n- Book your party online")
    let banquetHall = MapGalleries(name: "Banquet Hall", image1: #imageLiteral(resourceName: "banquet2"), info: "24. Banquet Rooms\n- Weddings\n- Corporate Meetings\n- Company Parties")
    let amenities = MapGalleries(name: "Amenities", image1: #imageLiteral(resourceName: "giftShop"), info: "25. Cafe Avalon\n26. Aquarium Gift Shop\n27. 4D Theatre (second floor)\n- Wheelchair accessible\n- Lost & Found items held at the information desk\n- Free Wi-Fi available")
    let jellyFish = MapGalleries(name: "Invertebrates", image1: #imageLiteral(resourceName: "jellyfish"), info: "5. NOAA Research Vessel\n6. Sea Jellies")
    let theater = MapGalleries(name: "4D Theater", image1: #imageLiteral(resourceName: "theater"), info: "Experience the world of 4D! Moving beyond the realm of 3D, our features will let you feel the spray of the ocean, the rumble of the earth and even smell the salty sea air.\n\nTickets are included with every General Admission ticket!")
    let educationCenter = MapGalleries(name: "Education Center", image1: #imageLiteral(resourceName: "education"), info: "The educational mission of the Loveland Living Planet Aquarium is to provide unique learning environments for learners of all ages to encourage an ongoing discovery of the Earth’s diverse, yet fragile ecosystems.")
    let deepSeaLab = MapGalleries(name: "Deep Sea Lab", image1: #imageLiteral(resourceName: "deepSea"), info: "Come see and experience the animals that live in the deep sea.  These animals have evolved to live in deep seas most humans have yet to discover. Some of these creatures are such perfect scavengers that they have thrived and lived in deep seas for millions of years.")
    let cafe = MapGalleries(name: "Cafe Avalon", image1: #imageLiteral(resourceName: "cafeLogo"), info: "Cafe Avalon offers a fine selection of refreshments, from hot sandwiches to on-the-go snacks. Located in the main lobby.")
}
