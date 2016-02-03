//
//  SearchResultsViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/31/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Controls LandingPage when search is in progress.
//  Manages subviews responsible for different aspects of search results view.
//

import Foundation
import UIKit

class SearchResultsViewController : UIViewController {
    
    // MARK: Properties
    
    // strings for display
    let NEED_LOGIN_TITLE = "Not Signed In"
    let NEED_LOGIN_MSG = "You need to sign in to do this!"
    
    // segues corresponding to embedded subviews
    let segueEmbedSearchResults = "goToSearchResults"
    let segueEmbedFilterBar = "goToFilterBar"
    let segueEmbedHotpot = "goToHotpot"
    
    // variables to hold the subview controllers (SVCs)
    var searchResultsSVC : SearchResultsSubviewController?
    var filterBarSVC : UIViewController?
    var hotpotSVC : HotpotSubviewController?
    
    // containers of subviews
    @IBOutlet weak var searchResultsContainer: UIView!
    @IBOutlet weak var filterBarContainer: UIView!
    @IBOutlet weak var hotpotContainer: UIView!
    
    // MARK: Actions
    
    /* prepareForSegue
        - prepares for segue
        - sets variables to keep track of embedded SVCs
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // keep track of the embedded subview controllers
        let vc = segue.destinationViewController
        switch segue.identifier! {
        case segueEmbedSearchResults:
            searchResultsSVC = vc as? SearchResultsSubviewController
            break
        case segueEmbedFilterBar:
            filterBarSVC = vc
            break
        case segueEmbedHotpot:
            hotpotSVC = vc as? HotpotSubviewController
            break
        default:
            break
        }
    }
    
    /* newSearchTermWasAddded
        - refreshes hotpot to reflect changes to search query
    */
    func newSearchTermWasAdded() {
        hotpotSVC?.collectionView?.reloadData()
        searchResultsSVC?.getSearchResults()
    }
    
    /* goToNewSearch
        - checks if hotpot is empty and if so, tells page to load new search view
    */
    func hotpotIngredientWasRemoved() {
        if currentSearch.isEmpty {
            if let parent = parentViewController as? ContainerViewController {
                if let page = parent.parentViewController as? LandingPageController {
                    page.goToNewSearch()
                }
            } else {
                print("ERROR: Landing page hierarchy broken for Search Results VC.")
            }
        } else {
            searchResultsSVC?.getNewSearchResults()
        }
    }
    
    /* goToNewSearch
        - subview controllers call this to indicate user attempted action
        that required login but was not logged in
        - creates sign-in alert (may at later date delegate alert to something else)
    */
    func mustBeSignedIn() {
        alertPopup(self.NEED_LOGIN_TITLE,
            msg: self.NEED_LOGIN_MSG as String,
            actionTitle: OK_TEXT,
            currController: self)
    }
    
}