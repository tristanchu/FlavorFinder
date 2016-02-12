//
//  LandingPageController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//  inspiration drawn from http://sandmoose.com/post/35714028270/storyboards-with-custom-container-view-controllers
//
//  This VC controls logic related to: do we have a search or are we waiting for a new search?
//  It SHOULD NOT handle login logic etc. It CAN hold onto search information for its child views.
//

import Foundation
import UIKit
import Parse

class LandingPageController: ContainerParentViewController {

    // MARK: Properties:

    // visual:
    let searchTitle = "Search"

    // Segues:
    let segueLandingEmbedded = "segueLandingEmbedSubview"
    let segueToSearchResults = "segueLandingToSearchResults"
    let segueToNewSearch = "segueLandingToNewSearch"

    // MARK: Actions
    
    /* viewDidLoad
        runs when user goes to view:
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /* viewDidAppear
        runs when user goes to view:
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get navigation bar on top:
        if let navi = self.tabBarController?.navigationController
            as? MainNavigationController {
                self.tabBarController?.navigationItem.setLeftBarButtonItems(
                    [], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                navi.reset_navigationBar()
                self.tabBarController?.navigationItem.title = searchTitle
        }
        
        self.tabBarController?.navigationItem.title = ""
        
        // load the appropriate subviews (new search or search results)
        if !(currentSearch.isEmpty) {
            goToSearchResults()
        } else {
            goToNewSearch()
        }
    }

    /* prepareForSegue
        - prepares for segue
        - sets value for variable inherited from ContainerParentController s.t.
        embedded content via ContainerViewController can be tracked
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.segueEmbeddedContent == nil {
            self.setValue(segueLandingEmbedded, forKey: "segueEmbeddedContent")
        }
        super.prepareForSegue(segue, sender: sender)
    }

    /* goToNewSearch
        - loads new search view for landing page
        - should be called when there is no search in progress
    */
    func goToNewSearch() {
        containerVC?.segueIdentifierReceivedFromParent(segueToNewSearch)
    }
    
    /* goToSearchResults
        - loads search results view for landing page
        - should be called when user initiates a search
    */
    func goToSearchResults() {
        containerVC?.segueIdentifierReceivedFromParent(segueToSearchResults)
    }

}
