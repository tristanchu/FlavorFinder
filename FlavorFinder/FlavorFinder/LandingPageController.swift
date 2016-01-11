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



//
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    return YES;
//    }


///'NSInternalInconsistencyException', reason: 'Could not create a segue of class '(null)''


class LandingPageController: UIViewController {
    var gotSearch = true
    var containerVC: ContainerViewController?
    let segueEmbeddedContent = "segueLandingEmbedSubview"
    let segueToSearchResults = "segueLandingToSearchResults"
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        containerVC?.view.backgroundColor = MATCH_HIGH_COLOR
        if gotSearch {
            print("got search")
            containerVC!.segueIdentifierReceivedFromParent(segueToSearchResults)
        } else {
            print("no search")
        }
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueEmbeddedContent {
            self.containerVC = segue.destinationViewController as? ContainerViewController
        }
        if segue.identifier == segueToSearchResults {
            containerVC = segue.destinationViewController as? ContainerViewController
        }
    }
    
}
