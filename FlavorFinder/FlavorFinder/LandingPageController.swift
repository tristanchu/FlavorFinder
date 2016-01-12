//
//  LandingPageController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//  inspiration drawn from http://sandmoose.com/post/35714028270/storyboards-with-custom-container-view-controllers
//

import Foundation
import UIKit
import Parse

class LandingPageController: UIViewController {
    var gotSearch = true
    var containerVC: ContainerViewController?
    let segueEmbeddedContent = "segueLandingEmbedSubview"
    let segueToSearchResults = "segueLandingToSearchResults"
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if gotSearch {
            print("got search")
            containerVC?.segueIdentifierReceivedFromParent(segueToSearchResults)
        } else {
            print("no search")
            containerVC?.view.backgroundColor = MATCH_HIGH_COLOR
        }
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueEmbeddedContent {
            print("loading content")
            containerVC = segue.destinationViewController as? ContainerViewController
        }
    }
    
}
