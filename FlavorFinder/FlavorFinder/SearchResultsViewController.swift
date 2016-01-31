//
//  SearchResultsViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/31/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Controls LandingPage when search is in progress.
//  Manages subviews responsible for different aspects of search results view
//  by maintaining knowledge of the current search.
//

import Foundation
import UIKit

class SearchResultsViewController : UIViewController {
    
    // segues corresponding to embedded subviews
    let segueEmbedSearchResults = "goToSearchResults"
    let segueEmbedFilterBar = "goToFilterBar"
    let segueEmbedHotpot = "goToHotpot"
    
    // variables to hold the subview controllers (SVCs)
    var searchResultsSVC : UIViewController?
    var filterBarSVC : UIViewController?
    var hotpotSVC : UIViewController?
    
    // containers of subviews
    @IBOutlet weak var searchResultsContainer: UIView!
    @IBOutlet weak var filterBarContainer: UIView!
    @IBOutlet weak var hotpotContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // insert initial search logic here...
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // keep track of the embedded subview controllers
        let vc = segue.destinationViewController
        switch segue.identifier! {
        case segueEmbedSearchResults:
            searchResultsSVC = vc
            break
        case segueEmbedFilterBar:
            filterBarSVC = vc
            break
        case segueEmbedHotpot:
            hotpotSVC = vc
            break
        default:
            break
        }
    }
}