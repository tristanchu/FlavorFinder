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
    // Vars:
    var gotSearch = true
    
    // visual:
    let searchTitle = "Search"

    // Segues:
    let segueLandingEmbedded = "segueLandingEmbedSubview"
    let segueToSearchResults = "segueLandingToSearchResults"
    let segueToNewSearch = "segueLandingToNewSearch"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    /* viewDidAppear
        runs when user goes to view:
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // load the appropriate subviews (new search or search results)
        if (currentSearch.count != 0) {
            print("DEBUG: got search");
            goToSearchResults();
        } else {
            print("DEBUG: new search");
            goToNewSearch();
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.segueEmbeddedContent == nil {
            self.setValue(segueLandingEmbedded, forKey: "segueEmbeddedContent")
        }
        super.prepareForSegue(segue, sender: sender)
    }

    func goToNewSearch() {
        containerVC?.segueIdentifierReceivedFromParent(segueToNewSearch)
    }

    func goToSearchResults() {
        containerVC?.segueIdentifierReceivedFromParent(segueToSearchResults)
        /// need to handle search terms >> self.terms becomes child's segue's sender.terms?
        /// newsearch child can pass along terms from the search bar, which triggers this perhaps...
    }

}
