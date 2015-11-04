//
//  MatchTableViewController.swift
//  FlavorFinder
//
//  Created by Jon on 10/8/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit
import SQLite
import Parse
import FontAwesome_swift
import Darwin

class MatchTableViewController: UITableViewController, UISearchBarDelegate {
    // GLOBALS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // -------
    var allCells = [PFObject]()       // Array of all cells that CAN be displayed.
    var filteredCells = [PFObject]()  // Array of all cells that ARE displayed (filtered version of 'allCells').
    var viewingMatches = false          // Activates colored backgrounds. Only want to show colors when viewing matches, not all ingredients.
    var currentIngredient : PFObject? // Stores the ingredient being viewed (nil for all ingredients).
    
    var searchBarActivateBtn: UIBarButtonItem = UIBarButtonItem()
    var searchBar = UISearchBar()
    
    @IBOutlet var matchTableView: UITableView!
    
    let EDIT_COLOR = UIColor(red: 249/255.0, green: 69/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
    let YUCK_COLOR = UIColor(red: 255/255.0, green: 109/255.0, blue: 69/255.0, alpha: CGFloat(0.3))
    let YUM_COLOR = UIColor(red: 61/255.0, green: 235/255.0, blue: 64/255.0, alpha: CGFloat(0.3))
    
    // SETUP FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ---------------
    override func viewDidLoad() {
        super.viewDidLoad()

        configure_searchBar()
        configure_searchBarActivateBtn()
        
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([navi.goBackBtn, self.searchBarActivateBtn], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.goForwardBtn, navi.menuBarBtn], animated: true)
            navi.reset_navigationBar()
            navi.goBackBtn.enabled = false
            navi.goForwardBtn.enabled = false
        }
        showAllIngredients()
    }
    
    func configure_searchBarActivateBtn() {
        searchBarActivateBtn.setTitleTextAttributes(attributes, forState: .Normal)
        searchBarActivateBtn.title = String.fontAwesomeIconWithName(.Search)
        searchBarActivateBtn.tintColor = NAVI_BUTTON_COLOR
        searchBarActivateBtn.target = self
        searchBarActivateBtn.action = "searchBarActivateBtnClicked"
    }
    
    func configure_localSearchBar() {
        searchBar.delegate = self
        let y_offset = UIApplication.sharedApplication().statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height)!
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
        searchBar.frame = CGRect(x: 0, y: y_offset, width: screenWidth, height: 44)
        self.tableView.tableHeaderView = self.searchBar
    }
    
    func configure_searchBar() {
        searchBar.delegate = self
        searchBar.hidden = true
        searchBar.setShowsCancelButton(true, animated: false)
        let cancelButton = searchBar.valueForKey("cancelButton") as! UIButton
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        cancelButton.setTitle(String.fontAwesomeIconWithName(.ChevronLeft), forState: UIControlState.Normal)
    }
    
    func showAllIngredients() {
        viewingMatches = false
        allCells = _allIngredients
        filteredCells = _allIngredients
        self.navigationController?.navigationItem.title = TITLE_ALL_INGREDIENTS
        currentIngredient = nil
        
        animateTableViewCellsToLeft(self.tableView)
    }
    
    func showIngredient(ingredient: PFObject) {
        currentIngredient = ingredient
        self.navigationController?.navigationItem.title = ingredient[_s_name] as? String   // Set navigation title to ingredient's name.
        
        allCells.removeAll()

        let matches = _getMatchesForIngredient(ingredient)
        for match in matches {
            let matchIngredient: PFObject? = _getIngredientForMatch(match)
            if let matchIngredient = matchIngredient {
                allCells.append(matchIngredient)
            }
        }
//        let matches = matchesTable.filter(SCHEMA_COL_ID == ingredient[_s_objectId])   // Get all the match ids of matches for this ingredient.
//        
//        // Reset 'allCells' with the ingredients that have those match ids.
//        allCells.removeAll()
//        for m in db.prepare(matches) {
//            if let found = allIngredients.lazy.map({ $0.id == m[SCHEMA_COL_MATCHID] }).indexOf(true) {
//                allIngredients[found].matchLevel = m[SCHEMA_COL_MATCHLEVEL]
//                allCells.append(allIngredients[found])
//            }
//        }
        
        filteredCells = allCells                        // Reset 'filteredCells' with new matches.
        viewingMatches = true                           // Activates colored backgrounds. Only want to show colors when viewing matches, not all ingredients.
        animateTableViewCellsToLeft(self.tableView)     // Show the new ingredients on our table with animation.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TABLE FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ---------------
    override func viewWillAppear(animated: Bool) {
        animateTableViewCellsToLeft(self.tableView)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCells.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = CELLIDENTIFIER_MATCH
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatchTableViewCell

        let ingredient = filteredCells[indexPath.row]           // Fetches the appropriate ingredient to display.
        cell.nameLabel.text = ingredient[_s_name] as? String    // Set's the cell label to the ingredient's name.
        
        if viewingMatches {
            switch _getMatchLevelForIngredientAndMatch(currentIngredient!, Ingredient_match: ingredient) {
                
            case 1:
                cell.backgroundColor = MATCH_LOW_COLOR          // match: low, white
            case 2:
                cell.backgroundColor = MATCH_MEDIUM_COLOR       // match: medium, yellow
            case 3:
                cell.backgroundColor = MATCH_HIGH_COLOR         // match: high, blue
            case 4:
                cell.backgroundColor = MATCH_GREATEST_COLOR     // match: greatest, green
            default:
                cell.backgroundColor = MATCH_LOW_COLOR
            }
        } else {
            cell.backgroundColor = MATCH_LOW_COLOR
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if let navi = self.navigationController as? MainNavigationController {
            if (navi.dropdownIsDown) {
                navi.dismissMenuTableView()
            } else {
                navi.pushToHistory()                                                      // Push current ingredient to history stack.
                tableView.contentOffset = CGPointMake(0, 0 - tableView.contentInset.top); // Reset scroll position.
                let ingredient = filteredCells[indexPath.row]                             // Get tapped ingredient.
                showIngredient(ingredient)
            }
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        if let curr = currentIngredient {
            UIButton.appearance().setAttributedTitle(NSAttributedString(string: "", attributes: attributes), forState: .Normal)
            
            let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
                print("edit button tapped")
            }
            edit.backgroundColor = EDIT_COLOR
            
            let yuck = UITableViewRowAction(style: .Normal, title: "Yuck") { action, index in
                print("yuck button tapped")
                if let curr = self.currentIngredient {
                    let match1_objectId = curr[_s_objectId] as! String
                    let match2_objectId = self.filteredCells[indexPath.row][_s_objectId] as! String
                    downvoteMatch(match1_objectId, match2_objectId: match2_objectId)
                }
            }
            yuck.backgroundColor = YUCK_COLOR
            
            let yum = UITableViewRowAction(style: .Normal, title: "Yum") { action, index in
                print("yum button tapped")
                if let curr = self.currentIngredient {
                    let match1_objectId = curr[_s_objectId] as! String
                    let match2_objectId = self.filteredCells[indexPath.row][_s_objectId] as! String
                    upvoteMatch(match1_objectId, match2_objectId: match2_objectId)
                }
            }
            yum.backgroundColor = YUM_COLOR
            
            return [yum, yuck, edit]
//        }
    
    }
    
    // SEARCHBAR FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // -------------------
    func searchBarActivateBtnClicked() {
        showSearchBar()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideSearchBar()
        filterResults("")
    }
    
    func showSearchBar() {
        self.navigationController?.navigationItem.titleView = searchBar
        searchBar.alpha = 0
        self.searchBar.hidden = false
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([navi.goBackBtn], animated: true)
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.searchBar.alpha = 1
            }, completion: { finished in
                self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        if let navi = self.navigationController as? MainNavigationController {
            var newTitle = ""
            if let curr = currentIngredient {
                newTitle = curr[_s_name] as! String
            } else {
                newTitle = TITLE_ALL_INGREDIENTS
            }
            
            self.searchBar.alpha = 1
            UIView.animateWithDuration(0.3, animations: {
                self.searchBar.alpha = 0
                navi.navigationItem.title = newTitle
                
                navi.navigationItem.setLeftBarButtonItems([navi.goBackBtn, self.searchBarActivateBtn], animated: true)

                }, completion: { finished in
                    navi.navigationItem.titleView = nil
            })
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterResults(searchText)
    }
    
    func filterResults(searchText: String) {
        filteredCells.removeAll()
        
        if searchText.isEmpty {
            filteredCells = allCells
            searchBar.text = ""
        } else {
            for ingredient in allCells {
                if (ingredient[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
                    filteredCells.append(ingredient)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
}
