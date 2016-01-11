//
//  LandingPageController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LandingPageController: UIViewController, UITextFieldDelegate {
    var gotSearch = false
    let segueToSearchResults = "segueLandingToSearchResults"
    @IBOutlet weak var LandingContainerView: UIView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LandingContainerView.backgroundColor = MATCH_HIGH_COLOR
        if gotSearch {
            print("got search")
            self.performSegueWithIdentifier(segueToSearchResults, sender: nil)
        } else {
            print("no search")
        }
    }
}
