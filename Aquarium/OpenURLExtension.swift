//
//  OpenURLExtension.swift
//  Aquarium
//
//  Created by TLPAAdmin on 7/21/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(NSURL(string: url)! as URL) {
                application.open((NSURL(string: url)! as URL), options: [:], completionHandler: nil)
                return
            }
        }
    }
}
