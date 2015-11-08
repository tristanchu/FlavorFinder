//
//  GlobalSearchController.swift
//  FlavorFinder
//
//  Created by Jon on 10/31/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

class GlobalSearchController: UITableViewController, UISearchBarDelegate {
    var allCells:[PFObject] = _allIngredients      // Array of all cells that CAN be displayed.
    var filteredCells: [PFObject] = _allIngredients  // Array of all cells that ARE displayed (filtered version of 'allCells').

    lazy var searchBar = UISearchBar(frame: CGRectMake(0, 0, 0, 0))
    var navi: MainNavigationController?

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCells.removeAll()
        
        if searchBar.text!.isEmpty {
            filteredCells = allCells
            searchBar.text = ""
        } else {
            for ingredient in allCells {
                if (ingredient[_s_name] as! String).rangeOfString(searchBar.text!.lowercaseString) != nil {
                    filteredCells.append(ingredient)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCells.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = CELLIDENTIFIER_MATCH
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatchTableViewCell
        
        // Fetches the appropriate ingredient to display.
        let ingredient = filteredCells[indexPath.row]
        
        // Set's the cell label to the ingredient's name.
        cell.nameLabel.text = ingredient[_s_name] as? String
        
        cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(0.3))

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let navi = self.navigationController as? MainNavigationController {
            if let matchTableViewControllerObject = navi.visibleViewController as? MatchTableViewController {
                matchTableViewControllerObject.showAllIngredients()
            } else {
                let mainStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let matchTableViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier(MatchTableViewControllerIdentifier) as? MatchTableViewController
                navi.pushViewController(matchTableViewControllerObject!, animated: true)
                matchTableViewControllerObject!.showAllIngredients()
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        navi?.hideSearchBar()
        if let matchTableViewControllerObject = navi?.visibleViewController as? MatchTableViewController {
            matchTableViewControllerObject.filterResults("")
        }
    }
    
//    func hideSearchBar() {
//        var newTitle = ""
//        if let matchTableViewControllerObject = navi?.visibleViewController as? MatchTableViewController {
//            if let curr = matchTableViewControllerObject.currentIngredient {
//                newTitle = curr.name
//            } else {
//                newTitle = TITLE_ALL_INGREDIENTS
//            }
//        }
//        
//        self.searchBar.alpha = 1
//        searchTableView.alpha = 1
//        UIView.animateWithDuration(0.3, animations: {
//            self.searchBar.alpha = 0
//            self.title = newTitle
//            
//            self.navigationItem.setLeftBarButtonItems([navi?.goBackBtn, navi?.searchBarActivateBtn], animated: true)
//            
//            self.searchTableView.alpha = 0
//            }, completion: { finished in
//                self.navigationItem.titleView = nil
//        })
//    }

}
