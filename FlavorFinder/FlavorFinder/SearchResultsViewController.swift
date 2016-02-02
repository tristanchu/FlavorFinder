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
    }
    
    /* goToNewSearch
        - checks if hotpot is empty and if so, tells page to load new search view
    */
    func hotpotIngredientWasRemoved() {
        if currentSearch.count == 0 {
            if let parent = parentViewController as? ContainerViewController {
                if let page = parent.parentViewController as? LandingPageController {
                    page.goToNewSearch()
                }
            } else {
                print("ERROR: Landing page hierarchy broken for Search Results VC.")
            }
        }
    }
    
}