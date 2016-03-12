//
//  SearchIngredientsViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Most of this was intiially written by Courtney for the EditListPage class.
//  Tweaked for reuse by Jaki so that it could be shared by the AddToFavViewController class.
//

import Foundation
import UIKit
import Parse

class SearchIngredientsViewController: GotNaviViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
// MARK: Properties: ----------------------------------------------------

    var ingredientSearchBar : UISearchBar?
    var searchTable : UITableView?
    
    var activeSearch : Bool = false
    
    var allIngredients : [PFIngredient]?
    var filteredResults : [PFIngredient] = []
    let CELL_IDENTIFIER = "searchResultCell"
    
// MARK: Override methods: ----------------------------------------------
    
    /* viewDidLoad:
     - Additional setup after loading the view
    */
    override func viewDidLoad() {
        
        if !isUserLoggedIn() {
            self.navigationController?.popToRootViewControllerAnimated(true)
            return
        }
        
        super.viewDidLoad()
        
        // set up delegates search bar and table view:
        ingredientSearchBar?.delegate = self
        searchTable?.delegate = self
        searchTable?.dataSource = self
        
        // set up table view details:
        searchTable?.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    /* viewDidAppear:
    - Setup when user goes into page
    */
    override func viewDidAppear(animated: Bool) {
        
        if !isUserLoggedIn() {
            self.navigationController?.popToRootViewControllerAnimated(true)
            return
        }
        
        super.viewDidAppear(animated)
        
        // Hide search bar results on load:
        searchTable?.hidden = true
        
    }
    
// MARK: Delegate/DataSource protocol functions ----------------------
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        activeSearch = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        activeSearch = false
        searchTable?.hidden = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        activeSearch = false
        searchTable?.hidden = true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        activeSearch = false
        searchTable?.hidden = true
    }
    
    /* searchBar
    - gives table view ingredients filtered by search:
    */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // fills filteredResults based on text entered
        filteredResults = getPossibleIngredients(searchText)
        if filteredResults.isEmpty {
            activeSearch = false
            searchTable?.hidden = true
        } else {
            activeSearch = true
            searchTable?.hidden = false
        }
        self.searchTable?.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /* tableView -- UITableViewDelegate func
    - returns number of rows to display
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activeSearch {
            return filteredResults.count
        }
        // have no cells if no search:
        return 0
    }
    
    /* tableView - UITableViewDelegate func
    - cell logic
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = searchTable?.dequeueReusableCellWithIdentifier(
            CELL_IDENTIFIER, forIndexPath: indexPath)
        // set cell label:
        cell?.textLabel?.text = filteredResults[indexPath.item].name
        // Give cell a chevron:
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    
    /* tableView -> happens on selection of row
    - sets selected row to current search
    - goes to search result view
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // make selected row the current search:
        let selected : PFIngredient = filteredResults[indexPath.row]
        gotSelectedIngredient(selected)
    }
    
// MARK: Functions to be overridden by child classes
    
    /* gotSelectedIngredient
    - do whatever you need to do with the selected ingredient from search
    */
    func gotSelectedIngredient(selected: PFIngredient) {}

}