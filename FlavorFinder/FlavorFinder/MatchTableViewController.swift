//
//  MatchTableViewController.swift
//  FlavorFinder
//
//  Created by Sudikoff Lab iMac on 10/8/15.
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
    var allCells = [Ingredient]()       // Array of all cells that CAN be displayed.
    var filteredCells = [Ingredient]()  // Array of all cells that ARE displayed (filtered version of 'allCells').
    var viewingMatches = false          // Activates colored backgrounds. Only want to show colors when viewing matches, not all ingredients.
    var currentIngredient : Ingredient? // Stores the ingredient being viewed (nil for all ingredients).
    

    
    var menuTableView: UITableView = UITableView()
    var menuTableItems = [  String.fontAwesomeIconWithName(.User) + " Profile",
                            String.fontAwesomeIconWithName(.Cutlery) + " Ingredients",
                            String.fontAwesomeIconWithName(.SignOut) + " Sign Out"
                         ]
    var menuBtn: UIButton = UIButton()
    var menuBarBtn: UIBarButtonItem = UIBarButtonItem()
    
    var goBackBtn: UIBarButtonItem = UIBarButtonItem()
    var goForwardBtn: UIBarButtonItem = UIBarButtonItem()

    var searchBarActivateBtn: UIBarButtonItem = UIBarButtonItem()
    lazy var searchBar = UISearchBar(frame: CGRectMake(0, 0, 0, 0))
    
    let SEGUE_LOGOUT = "segueLogout"
    let TITLE_ALL_INGREDIENTS = "All Ingredients"
    let CELLIDENTIFIER_MENU = "menuCell"
    let CELLIDENTIFIER_MATCH = "MatchTableViewCell"
    
    let BUTTON_COLOR = UIColor(red: 165/255.0, green: 242/255.0, blue: 216/255.0, alpha: CGFloat(1))
    
    var dropdownIsDown = false
    
    @IBOutlet var matchTableView: UITableView!
    
    // NAVI FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // --------------

    
    // SETUP FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ---------------
    func configure_searchBar() {
        searchBar.delegate = self
        searchBar.hidden = true
        searchBar.setShowsCancelButton(true, animated: false)
        let cancelButton = searchBar.valueForKey("cancelButton") as! UIButton
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        cancelButton.setTitle(String.fontAwesomeIconWithName(.ChevronLeft), forState: UIControlState.Normal)
    }
    
//    func configure_navigationBar() {
//        // Disable buttons by default.
//        goBackBtn.enabled = false
//        goForwardBtn.enabled = false
//    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // Update position of menu so it stays on screen.
        var frame = self.menuTableView.frame
        frame.origin.y = UIApplication.sharedApplication().statusBarFrame.size.height +
                            (self.navigationController?.navigationBar.frame.height)! +
                            scrollView.contentOffset.y
        self.menuTableView.frame = frame
        self.view.bringSubviewToFront(menuTableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure_searchBar()
        
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([navi.goBackBtn, navi.searchBarActivateBtn], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.goForwardBtn, navi.menuBarBtn], animated: true)
            navi.navigationItem.title = ""
            navi.dismissMenuTableView()
        }
        showAllIngredients()
    }
    
    func showAllIngredients() {
        viewingMatches = false
        allCells = allIngredients
        filteredCells = allIngredients
        self.navigationController?.navigationItem.title = TITLE_ALL_INGREDIENTS
        currentIngredient = nil
        
        animateTable()
    }
    
    func showIngredient(ingredient: Ingredient) {
        currentIngredient = ingredient
        self.navigationController?.navigationItem.title = ingredient.name   // Set navigation title to ingredient's name.
        let matches = matchesTable.filter(SCHEMA_COL_ID == ingredient.id)   // Get all the match ids of matches for this ingredient.
        
        // Reset 'allCells' with the ingredients that have those match ids.
        allCells.removeAll()
        for m in db.prepare(matches) {
            if let found = allIngredients.lazy.map({ $0.id == m[SCHEMA_COL_MATCHID] }).indexOf(true) {
                allIngredients[found].matchLevel = m[SCHEMA_COL_MATCHLEVEL]
                allCells.append(allIngredients[found])
            }
        }
        
        filteredCells = allCells        // Reset 'filteredCells' with new matches.
        viewingMatches = true           // Activates colored backgrounds. Only want to show colors when viewing matches, not all ingredients.
        animateTable()                  // Show the new ingredients on our table with animation.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TABLE FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ---------------
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    // Function to animate all table cells on load.
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableWidth: CGFloat = tableView.bounds.size.width
        
        for i in cells {
            let cell: UITableViewCell = i 
            cell.transform = CGAffineTransformMakeTranslation(tableWidth, 0)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a 
            UIView.animateWithDuration(0.75, delay: 0.03 * Double(index), usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
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

        // Fetches the appropriate ingredient to display.
        let ingredient = filteredCells[indexPath.row]
        
        // Set's the cell label to the ingredient's name.
        cell.nameLabel.text = ingredient.name
        
        if viewingMatches {
            switch ingredient.matchLevel {
                
            // Match: low. White.
            case 1:
                cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
            // Match: medium. Yellow.
            case 2:
                cell.backgroundColor = UIColor(red: 255/255.0, green: 237/255.0, blue: 105/255.0, alpha: CGFloat(0.3))
            // Match: high. Blue.
            case 3:
                cell.backgroundColor = UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
            // Match: greatest. Green.
            case 4:
                cell.backgroundColor = UIColor(red: 105/255.0, green: 255/255.0, blue: 150/255.0, alpha: CGFloat(0.3))
            // Default. White.
            default:
                cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
            }
        } else {
            cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
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
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            print("edit button tapped")
        }
        edit.backgroundColor = UIColor(red: 249/255.0, green: 69/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
        
        let yucky = UITableViewRowAction(style: .Normal, title: "Yucky") { action, index in
            print("yucky button tapped")
        }
        yucky.backgroundColor = UIColor(red: 255/255.0, green: 109/255.0, blue: 69/255.0, alpha: CGFloat(0.3))
        
        let yummy = UITableViewRowAction(style: .Normal, title: "Yummy") { action, index in
            print("yummy button tapped")
        }
        yummy.backgroundColor = UIColor(red: 61/255.0, green: 235/255.0, blue: 64/255.0, alpha: CGFloat(0.3))
        
        return [edit, yucky, yummy]
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
//    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
//            // OPEN UIPresentationController HERE
//            let vc = UIViewController(nibName: nil, bundle: nil)
//            vc.view.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//            vc.view.backgroundColor = UIColor.orangeColor()
//            vc.modalPresentationStyle = .Popover
//            
//            let popover = vc.popoverPresentationController!
//            let cell = tableView.cellForRowAtIndexPath(indexPath)!
//            
//            var cellAbsolutePosition = cell.superview!.convertPoint(cell.frame.origin, toView: nil)
//            cellAbsolutePosition.x = cell.frame.width - 60
//            popover.sourceRect = CGRect(origin: cellAbsolutePosition, size: cell.frame.size)
//            popover.sourceView = tableView
//            
//            self.presentViewController(vc, animated: true, completion: nil)
//        }
//        return [edit]
//    }
    
    
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
        navigationItem.titleView = searchBar
        searchBar.alpha = 0
        self.searchBar.hidden = false
        self.navigationItem.setLeftBarButtonItems([goBackBtn], animated: true)
        
        UIView.animateWithDuration(0.5, animations: {
            self.searchBar.alpha = 1
            }, completion: { finished in
                self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        var newTitle = ""
        if let curr = currentIngredient {
            newTitle = curr.name
        } else {
            newTitle = TITLE_ALL_INGREDIENTS
        }
        
        self.searchBar.alpha = 1
        UIView.animateWithDuration(0.3, animations: {
            self.searchBar.alpha = 0
            self.navigationController?.navigationItem.title = newTitle
            
            self.navigationItem.setLeftBarButtonItems([self.goBackBtn, self.searchBarActivateBtn], animated: true)

            }, completion: { finished in
                self.navigationItem.titleView = nil
        })
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
                if ingredient.name.rangeOfString(searchText.lowercaseString) != nil {
                    filteredCells.append(ingredient)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
}
