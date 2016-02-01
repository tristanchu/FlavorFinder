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
    var gotSearch = false
    let segueLandingEmbedded = "segueLandingEmbedSubview"
    let segueToSearchResults = "segueLandingToSearchResults"
    let segueToNewSearch = "segueLandingToNewSearch"

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // load the appropriate subviews (new search or search results)
        if gotSearch {
            print("DEBUG: got search")
            goToSearchResults()
        } else {
            print("DEBUG: new search")
            goToNewSearch()
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
