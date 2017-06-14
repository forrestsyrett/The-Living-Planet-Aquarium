//
//  TheaterShowsController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 4/13/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit


class TheaterShowsController {
    
    static let shared = TheaterShowsController()
    
    let wildCats3D = TheaterShows(title: "Wild Cats 3D", showtimes: "Show Times\n10:45 am\n12:10 pm\n1:35 pm\n3:00 pm\n4:25 pm", image: #imageLiteral(resourceName: "wild-cats-200px"))
    let penguins4D = TheaterShows(title: "Penguins 4D", showtimes: "Show Times\n11:15 am\n12:40 pm\n2:05 pm\n3:30 pm\n4:55 pm", image:#imageLiteral(resourceName: "penguins-200px"))
    let sammyAndRay4D = TheaterShows(title: "Sammy & Ray 4D", showtimes: "Show Times\n10:20 am\n11:45 am\n1:10 pm\n2:35 pm\n4:00 pm\n5:25 pm", image:#imageLiteral(resourceName: "sammy-and-ray-200-px"))
    
}
