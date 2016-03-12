//
//  NewSearchViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/13/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Handles search bar interaction on the new search state of the landing page.
//  Also handles logged in logic to determine whether or not to display login/register container.
//

import Foundation
import UIKit
import Parse

class NewSearchViewController : LoginModuleParentViewController,
        UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties -----------------------------------------

    // Search result properties:
    var activeSearch : Bool = false
    var allIngredients : [PFIngredient]? // set on load
    var filteredResults : [PFIngredient] = []
    let CELL_IDENTIFIER = "newSearchResultCell"

    // Navigation properties (passed in through segue):
    var buttonSegue : String!
    let segueLoginEmbedded = "segueLoginEmbedSubview"
    
    // Identifiers from storyboard: (note, constraints on there)
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appIconView: UIImageView!
    @IBOutlet weak var searchPrompt: UILabel!
    @IBOutlet weak var newSearchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!

    // MARK: Override Functions -----------------------------------------

    /* viewDidLoad
        - called when app first loaded
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLoginContainerUI()

        // set up delegates:
        newSearchBar.delegate = self
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self

        // Rounded edges for search bar:
        self.newSearchBar.layer.cornerRadius = ROUNDED_SIZE
        self.newSearchBar.clipsToBounds = ROUNDED_EDGES
    }

    /* viewDidAppear
        - called when user goes; to view
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Hide search bar results on load:
        searchResultTableView.hidden = true

        // Hide/Show login container based on if user is logged in:
        if isUserLoggedIn() {
            containerVC?.view.hidden = true
        } else {
            containerVC?.view.hidden = false
            
            // Shows login first
            goToLogin()
        }
    }
    
    /* prepareForSegue:
    - setup before seguing
    - prior to container's embed segue, will set up parent class variable to have
    access to contained VC
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.segueEmbeddedContent == nil {
            self.setValue(segueLoginEmbedded, forKey: "segueEmbeddedContent")
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    // MARK: UITableViewDataSource protocol functions ------------------------
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        activeSearch = true;
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        activeSearch = false;
        searchResultTableView.hidden = true
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        activeSearch = false;
        searchResultTableView.hidden = true
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        activeSearch = false;
        searchResultTableView.hidden = true
    }

    /* searchBar - for UITableViewDataSource
        gives table view ingredients filtered by search:
    */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        // fills filteredResults based on text entered
        filteredResults = getPossibleIngredients(searchText)
        if filteredResults.isEmpty {
            activeSearch = false
            searchResultTableView.hidden = true
        } else {
            activeSearch = true
            searchResultTableView.hidden = false
        }
        self.searchResultTableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /* tableView -- UITableViewDelegate func
        - returns number of rows to display
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(activeSearch) {
            return filteredResults.count
        }
        // have no cells if no search:
        return 0;
    }
    
    /* tableView - UITableViewDelegate func
        - cell logic
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = searchResultTableView.dequeueReusableCellWithIdentifier(
            CELL_IDENTIFIER, forIndexPath: indexPath)
        // set cell label:
        cell.textLabel?.text = filteredResults[indexPath.item].name
        // Give cell a chevron:
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell;
    }

    /* tableView -> happens on selection of row
        - sets selected row to current search
        - goes to search result view
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // make selected row the current search:
        currentSearch = [filteredResults[indexPath.row]]
        
        if let parent = parentViewController as? ContainerViewController {
            if let page = parent.parentViewController as? LandingPageController {
                page.goToSearchResults()
            }
        } else {
            print("ERROR: Landing page hierarchy broken for New Search VC.")
        }
    }

}