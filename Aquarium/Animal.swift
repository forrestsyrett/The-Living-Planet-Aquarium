//
//  Animal.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/23/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit

enum Animals {
    case otters
    case tortoise
    case arapaima
    case toucan
    case zebraShark
    case greenSeaTurtle
    case eel
    case penguins
    case cloudedLeopards
    case hornbill
    case binturong
    case jellyfish
    case blacktipReef
    
    struct Info {
        var name: String
        var description: String?
        var animalImage: UIImage
        var gallery: String
        var status: String
        
        
    }
    
    var info: Info {
        
        switch self {
            
        case .otters:
            return
                Info(name: "North American River Otters", description: "Type: Mammal\nDiet: Carnivorous\nAverage Life Span: 14 – 25 years\nSize: 3.7 feet (males) 3.2 feet (females)\nWeight: 11 – 30lbs\nConservation Status: Threatened", animalImage: UIImage(named: "otters")!, gallery: "Discover Utah", status: "Least Concern")
        case .tortoise:
            return
                Info(name: "Desert Tortoise", description: "Type: Reptile\nDiet: Herbivorous\nAverage Life Span: 50 - 80 years\nSize: 10 - 14 inches\nWeight: .04 - 11lbs\nConservation Status: Threatened", animalImage: UIImage(named: "tortoise")!, gallery: "Discover Utah", status: "Vulnurable")
        case .arapaima:
            return
                Info(name: "Giant Arapaima", description: "Type: Fish\nDiet: Carnivorous\nAverage Life Span: 15 – 20 years\nSize: 9 ft (2.75 m)\nWeight: Up to 440 lbs\nConservation Status: Unknown", animalImage: UIImage(named: "arapaima")!, gallery: "Journey to South America", status: "Unknown")
        case .toucan:
            return
                Info(name: "Swainson's Toucan", description: "Quick Facts:\nType: Bird\nDiet: Omnivorous\nLife Span: 12 - 20 Years\nSize: 11.5 – 29 in\nWeight: 130 – 680g (4.6oz – 24oz)\nConservation Status: Stable\n\n\nSwainson’s Toucan is the second largest species of toucan, growing to be around 56 cm (22 inches) in length, has 9 inch long wings and weighs around 1 ½ lbs.The body is mostly a dark black color, with maroon bordering the tail and the yellow throat and face. The large, hollow beak can grow up to 20 cm (7.8 inches) long and is bi-colored, split between yellow above and a chestnut to maroon color below (Chestnut-mandibled Toucan (Ramphastos swainsonii).\n\nMale and female Swainson’s Toucan look alike, but the males are slightly larger. Toucans can live 12-20 years, depending upon species; larger toucans have lived up to 25 years in captivity.\n\nRamphastos swainsonii is a frugivorous (fruit eating) bird that lives in the upper canopy of tropical rainforests. They will eat fruit from over 100 different species of trees which helps to scatter seeds all over the forest (Chestnut-mandibled Toucan (Ramphastos swainsonii)). R. swainsonii is a generalist when it comes to fruit and will eat most any type of fruit that is available. This toucan has also been observed to occasionally eat large insects, small lizards, eggs, and small or young birds. However, this is less than 10% of their usual diet, and appears to be mostly for their young, which require more protein.\n\nThe Swainson’s Toucan is a large bird and has few predators. Because of this it is a very calm bird that will often times ignore the warning cries of smaller birds. R. swainsonii are often observed grooming themselves, bathing, or simply standing still resting. Preening with the large bill can be difficult, and paired R. swainsonii will help to preen and groom each other.\n\nBreeding occurs from early April to June. R. swainsonii will lay 2-3 eggs at a time (Rice, Weckstein, & Engel, 2010). After incubating for 17-19 days the eggs will hatch. The young are in the fledgling stage for 5-6 weeks, and are capable of feeding themselves after 9 weeks.\n\nThe nestlings are born blind, with no trace of down on their pink skin. The chicks have pads on their elbows that protect and keep them elevated from the rough and damp floor. The bill is unremarkable until about 16 days old when it takes on the distinguishing features of the toucan.\n\nIt is believed that R. swainsonii will form long term pair bonds.", animalImage: UIImage(named: "toucan")!, gallery: "Journey to South America", status: "Least Concern")
        case .zebraShark:
            return
                Info(name: "Zebra Shark", description: "Type: Fish\nDiet: Omnivorous\nAverage Life Span: 15 - 20 Years\nSize: 2 – 8.2ft\nWeight: 35 - 44 lbs\nConservation Status: Threatened", animalImage: UIImage(named: "zebraShark")!, gallery: "Ocean Explorer", status: "Endangered")
        case .greenSeaTurtle:
            return
                Info(name: "Green Sea Turtle", description: "Type: Reptile\nDiet: Juveniles are omnivorous, Adults are mainly herbivorous\nAverage Life Span: Over 80 years\nSize: Up to 5 ft in length\nWeight: Up to 700 lbs\nConservation Status: Endangered", animalImage: #imageLiteral(resourceName: "seaturtle"), gallery: "Ocean Explorer", status: "Endangered")
        case .eel:
            return
                Info(name: "Green Moray Eel", description: "Type: Eel\nDiet: Carnivorous\nAverage Life Span: Estimated 8 - 30 years\nSize: Up to 5 ft in length\nWeight: Up to 65lbs\nConservation Status: Least Concern", animalImage: UIImage(named: "eel")!, gallery: "Ocean Explorer", status: "Least Concern")
            
        case .penguins:
            return
                Info(name: "Gentoo Penguins", description: "Quick Facts:\nType: Bird\nDiet: Carnivorous\nAverage Life Span: Up to 30 years in captivity\nSize: 30 in\nWeight: 12 lbs (5.5 kg)\nGroup Name: Colony\n\n\nWith flamboyant red-orange beaks, white-feather caps, and peach-colored feet, gentoo penguins stand out against their drab, rock-strewn Antarctic habitat.\n\nThese charismatic waddlers, who populate the Antarctic Peninsula and numerous islands around the frozen continent, are the penguin world’s third largest members, reaching a height of 30 inches (76 centimeters) and a weight of 12 pounds (5.5 kilograms).\n\nGentoos are partial to ice-free areas, including coastal plains, sheltered valleys, and cliffs. They gather in colonies of breeding pairs that can number from a few dozen to many thousands.\n\nGentoo parents, which often form long-lasting bonds, are highly nurturing. At breeding time, both parents will work to build a circular nest of stones, grass, moss, and feathers. The mother then deposits two spherical, white eggs, which both parents take turns incubating for more than a month. Hatchlings remain in the nest for up to a month, and the parents alternate foraging and brooding duties.\n\nGentoo penguins are pure grace underwater. They have streamlined bodies and strong, paddle-shaped flippers that propel them up to 22 miles an hour (36 kilometers an hour), faster than any other diving bird.\n\nAdults spend the entire day hunting, usually close to shore, but occasionally ranging as far as 16 miles (26 kilometers) out. When pursuing prey, which includes fish, squid, and krill, they can remain below for up to seven minutes and dive as deep as 655 feet (200 meters).\n\nGentoo penguins are a favored menu item of the leopard seals, sea lions, and orcas that patrol the waters around their colonies. On land, adults have no natural predators other than humans, who harvest them for their oil and skin. Gentoo eggs and chicks, however, are vulnerable to birds of prey, like skuas and caracaras.\n\nGentoo numbers are increasing on the Antarctic Peninsula but have plummeted in some of their island enclaves, possibly due to local pollution or disrupted fisheries.", animalImage: #imageLiteral(resourceName: "penguinsIllustration"), gallery: "Antarctic Adventure", status: "Least Concern")
            
        case .cloudedLeopards:
            return
                Info(name: "Clouded Leopard", description: "Type: Mammal\nDiet: Carnivorous\nLife Span: Up to 17 years in captivity\nSize: 27 - 32in (Female), 32 - 43in (male)\nWeight: 25 - 51 lbs\nConservation: Vulnerable", animalImage: UIImage(named: "cloudedLeopardIllustration")!, gallery: "Expedition Asia", status: "Vulnerable")
        case .hornbill:
            return
                Info(name: "Oriental Pied Hornbill", description: "Type: Bird\nDiet: Frugivore(Diet consists mainly of fruit)\nWing Span: 23 - 32cm\nSize: 55 - 60cm\nWeight: 600 - 1,050g\nConservation Status: Least Concern", animalImage: UIImage(named: "hornbill")!, gallery: "Expedition Asia", status: "Least Concern")
        case .binturong:
            return
                Info(name: "Binturong", description: "Type: Mammal\nDiet: Omnivorous\nLife Span: Up to 20 years\nSize: 2.3 - 2.8 feet\nWeight: 24 - 71 lbs\nConservation: Vulnerable", animalImage: UIImage(named: "binturong")!, gallery: "Expedition Asia", status: "Vulnerable")
        case .jellyfish:
            return
                Info(name: "Pacific Sea Nettle", description: "Quick Facts:\nType: Invertebrate\nDiet: ZooPlankton\nLife Span: 6 months - 1 year\nSize: 30 inches wide (tentacles can be as long as 16 feet)\nWeight: 0.2k\nConservation: Least Concern\n\n\nThe bell on a Pacific Sea Nettle can grow to more than 3 feet (1 m) in diameter, while the trailing tentacles can get to 12 or 15 feet (3.6 to 4.6 m) long. The bell is semi-transparent with either a white or reddish-brown tint to it. Usually the bell is striped. Pacific Sea Nettles are larger and darker than their cousin the Northern Sea Nettle (Chrysaora melanaster). They also have long lace-like oral arms in the center that transport food to their single mouth opening on the underside of their bell.\n\nPacific Sea Nettles feed on fish, zooplankton, and other jellies.\n\nThe lifespan for a Pacific Sea Nettle can be anywhere between 6 to 12 months. However, in the wild they can live closer to 18 months.\n\nSea Nettles, like most jellyfish species, travel in swarms. A Sea Nettle’s sting is very often deadly to proportionately sized prey. Their sting is rated from moderate to severe in regards to human interaction.\n\nThe jellyfish sting actually comes from tiny nematocysts, or stinging cells, on the jellyfish body. When triggered, these cells eject poison-tipped barbs that help the jellyfish catch food in the ocean. The nematocysts can still release their sting even after the jellyfish is dead.\n\nIndividual sea jellies are either male or female and reproduce sexually. Eggs and sperm develop inside the gonads and are released through the mouth into the ocean. The microscopic fertilized eggs begin a series of cell divisions which results in an embryo. The embryo does not develop directly into a baby sea jelly, but instead becomes a 'planula'. The planula is either carried with the current or uses cilia to swim until it finds its final resting place. After the tiny planula attaches to a rock or other substrate it immediately begins to grow into a polyp. The polyp can feed on passing plankton with its upward-facing tentacles. Grooves begin to appear and get deeper and deeper, cutting through the polyp’s body. The polyp then clones itself and reproduces asexually. A pile of disc-shaped structures emerge and one by one start to break away, each becoming a baby jelly, also called a free floating medusa. This is the form that most people recognize as a sea jelly.", animalImage: #imageLiteral(resourceName: "seaNettleIllustration"), gallery: "Antarctic Adventure", status: "Unknown")
        case .blacktipReef:
            return
                Info(name: "Blacktip Reef Shark", description: "The blacktip reef shark (Carcharhinus melanopterus) is a species of requiem shark, in the family Carcharhinidae, easily identified by the prominent black tips on its fins (especially on the first dorsal fin and its caudal fin). Among the most abundant sharks inhabiting the tropical coral reefs of the Indian and Pacific Oceans, this species prefers shallow, inshore waters. Its exposed first dorsal fin is a common sight in the region. Most blacktip reef sharks are found over reef ledges and sandy flats, though they have also been known to enter brackish and freshwater environments. This species typically attains a length of 1.6 m (5.2 ft).", animalImage: #imageLiteral(resourceName: "blacktipReefIllustration"), gallery: "Ocean Explorer", status: "Near Threatened")
        }
    }
    
}
