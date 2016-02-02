//
//  ContainerViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/11/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//  inspired by the tutorial here: https://kodesnippets.wordpress.com/2015/08/11/container-view-in-ios/
//
//  This is a flexible view controller class that can be used for view controllers that are attached via
//  embed segues to containers; in this way, this class switches out the content of that container to
//  the different view controllers based on the segue identifier passed to it by the parent view controller.
//  Thus, multiple subviews can be contained and swapped out by the parent of this view controller within one
//  container.
//

import Foundation
import UIKit

class ContainerViewController: UIViewController {

    // Segues: -- TODO: make globals:
    let segueToLogin = "goToLogin"
    let segueToRegister = "goToRegister"
    let segueToSearchResults = "segueLandingToSearchResults"
    let segueToNewSearch = "segueLandingToNewSearch"

    var vc : UIViewController!
    var segueIdentifier : String!
    var lastViewController: UIViewController!
    
    func segueIdentifierReceivedFromParent(segueID: String) {
        self.segueIdentifier = segueID
        self.performSegueWithIdentifier(self.segueIdentifier, sender:
            nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier {
            // Avoids creation of a stack of view controllers
            if lastViewController != nil {
                lastViewController.view.removeFromSuperview()
            }
            // Adds view controller to container and retains access to it via "vc" variable
            vc = segue.destinationViewController
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(vc.view)
            vc.didMoveToParentViewController(self)
            lastViewController = vc

            // For switching between views:
            if segue.identifier == segueToRegister {
                let register = segue.destinationViewController as! RegisterView
                register.parent = self
                register.buttonSegue = segueToLogin
            } else if segue.identifier == segueToLogin {
                let login = segue.destinationViewController as! LoginViewPage
                login.parent = self
                login.buttonSegue = segueToRegister
            } else if segue.identifier == segueToNewSearch {
                let newSearch = segue.destinationViewController as! NewSearchViewController
                newSearch.parent = self
                newSearch.buttonSegue = segueToSearchResults
            }
        }
    }
}