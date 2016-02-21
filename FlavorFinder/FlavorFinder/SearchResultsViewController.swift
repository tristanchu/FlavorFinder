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
    
    // Segues:
    let segueToAddHotpotToList = "segueToAddHotpotToList"
    
    // Buttons:
    let clearSearchBtn = UIBarButtonItem()
    let addToListBtn = UIBarButtonItem()
    
    // Button Text:
    let clearSearchText = String.fontAwesomeIconWithName(.ChevronLeft) + " New Search"
    let addToListText = String.fontAwesomeIconWithName(.Plus) + " Save Search to List"
    
    // Button Actions:
    let clearSearchSelector : Selector = "clearSearch"
    let addToListSelector : Selector = "addToListBtnClicked"
    
    // MARK: Actions
    
    // SETUP FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIBarButtons()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup navigation bar
        if let navi = self.tabBarController?.navigationController as? MainNavigationController {
            self.tabBarController?.navigationItem.setLeftBarButtonItems([clearSearchBtn], animated: true)
            self.tabBarController?.navigationItem.setRightBarButtonItems([addToListBtn], animated: true)
            navi.reset_navigationBar()
            self.tabBarController?.navigationItem.title = "Search"
        }
        
        // disable/enable add to list button if user:
        if currentUser != nil {
            self.addToListBtn.enabled = true
        } else {
            self.addToListBtn.enabled = false
        }
    }
    
    /* configureUIBarButtons
    - generates the UIBarButtonItem objects for the top nav bar
    */
    func configureUIBarButtons() {
        configureUIBarButtonItem(clearSearchBtn, title: clearSearchText, action: clearSearchSelector)
        configureUIBarButtonItem(addToListBtn, title: addToListText, action: addToListSelector)
    }
    
    /* configureUIBarButtonItem
    - sets attributes on a UIBarButtonItem to the preferred configuration
    */
    func configureUIBarButtonItem(button: UIBarButtonItem, title: String, action: Selector) {
        button.setTitleTextAttributes(attributes, forState: .Normal)
        button.title = title
        button.tintColor = NAVI_BUTTON_COLOR
        button.target = self
        button.action = action
    }
    
    // SUBVIEW MANAGEMENT FUNCTIONS

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
    
    // SUBVIEW RESPONSE FUNCTIONS

    /* newSearchTermWasAddded
        - refreshes hotpot to reflect changes to search query
    */
    func newSearchTermWasAdded() {
        hotpotSVC?.collectionView?.reloadData()
        searchResultsSVC?.getSearchResults()
    }
    
    /* hotpotIngredientWasRemoved
        - checks if hotpot is empty and if so, tells page to load new search view
    */
    func hotpotIngredientWasRemoved() {
        if currentSearch.isEmpty {
            if let parent = parentViewController as? ContainerViewController {
                if let page = parent.parentViewController as? LandingPageController {
                    resetNavBar()
                    page.goToNewSearch()
                }
            } else {
                print("ERROR: Landing page hierarchy broken for Search Results VC.")
            }
        } else {
            searchResultsSVC?.getNewSearchResults()
        }
    }
    
    /* clearSearch
        - executed when clearSearchButton is clicked
        - clears hotpot ingredients and goes back to landing page
    */
    func clearSearch() {
        currentSearch.removeAll()
        
        if let parent = parentViewController as? ContainerViewController {
            if let page = parent.parentViewController as? LandingPageController {
                resetNavBar()
                page.goToNewSearch()
            }
        } else {
            print("ERROR: Landing page hierarchy broken for Search Results VC.")
        }
    }
    
    /* resetNavBar
    - executed in hotpotIngredientWasRemoved() and clearSearch()
    - resets navbar to have no title nor buttons
    */
    func resetNavBar() {
        if let navi = self.tabBarController?.navigationController as? MainNavigationController {
            self.tabBarController?.navigationItem.setLeftBarButtonItems([], animated: true)
            self.tabBarController?.navigationItem.setRightBarButtonItems([], animated: true)
            navi.reset_navigationBar()
            self.tabBarController?.navigationItem.title = ""
        }
    }
    
    /* mustBeSignedIn
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

    /* filterButtonWasToggled
        - coordinates view response after child says filter buttons were toggled
    */
    func filterButtonWasToggled(filters: [String: Bool]) {
        searchResultsSVC?.filters = filters
    }
    
    func filterSearchTextDidChange(searchText: String) {
        searchResultsSVC?.filterResults(searchText)
    }
    
    /* addToListBtnClicked
    - presents modal view to then select a list
    */
    func addToListBtnClicked() {
        self.performSegueWithIdentifier(segueToAddHotpotToList, sender: self)
    }
    
}