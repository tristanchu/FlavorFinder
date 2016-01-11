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

class LandingPageController: UIViewController {
    var gotSearch = true
    var containerView: ContainerViewController?
    let segueToSearchResults = "segueLandingToSearchResults"
    
    @IBOutlet weak var LandingContainerView: UIView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        containerView = ContainerViewController()
        containerView?.setValue(LandingContainerView, forKey: "view")
        containerView?.view.backgroundColor = MATCH_HIGH_COLOR
        if gotSearch {
            print("got search")
            containerView!.segueIdentifierReceivedFromParent(segueToSearchResults)
        } else {
            print("no search")
        }
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == segueToSearchResults {
                containerView = segue.destinationViewController as? ContainerViewController
            }
    }
    
}
