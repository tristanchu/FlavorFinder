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
import MGSwipeTableCell
import DZNEmptyDataSet
import Darwin

class MatchTableViewController: UITableViewController, UISearchBarDelegate, MGSwipeTableCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // GLOBALS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // -------
    var allCells = [PFObject]()         // Array of all cells that CAN be displayed.
    var filteredCells = [PFObject]()    // Array of all cells that ARE displayed (filtered version of 'allCells').
    var currentIngredient : PFObject?   // Stores the ingredient being viewed (nil for all ingredients).
    
    var searchBarActivateBtn: UIBarButtonItem = UIBarButtonItem()
    var searchBar = UISearchBar()
    let notSignedInAlert = UIAlertController(title: "Not Signed In", message: "You need to sign in to do this!", preferredStyle: UIAlertControllerStyle.Alert)

    
    @IBOutlet var matchTableView: UITableView!
    
    let editCellBtnColor = UIColor(red: 249/255.0, green: 69/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
    let downvoteCellBtnColor = UIColor(red: 255/255.0, green: 109/255.0, blue: 69/255.0, alpha: CGFloat(0.3))
    let upvoteCellBtnColor = UIColor(red: 61/255.0, green: 235/255.0, blue: 64/255.0, alpha: CGFloat(0.3))
    
    // SETUP FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ---------------
    override func viewDidLoad() {
        super.viewDidLoad()

        configure_searchBar()
        configure_searchBarActivateBtn()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView();
        
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([navi.goBackBtn, self.searchBarActivateBtn], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.goForwardBtn, navi.menuBarBtn], animated: true)
            navi.reset_navigationBar()
            navi.goBackBtn.enabled = false
            navi.goForwardBtn.enabled = false
            
            
            notSignedInAlert.addAction(UIAlertAction(title: "Sign In", style: .Default, handler: { (action: UIAlertAction!) in
                let mainStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let loginViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier(LoginViewControllerIdentifier) as? LoginViewController
                navi.pushViewController(loginViewControllerObject!, animated: true)
            }))
            
            notSignedInAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
                self.notSignedInAlert.dismissViewControllerAnimated(true, completion: nil)
            }))
        }
        

        
        showAllIngredients()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = String.fontAwesomeIconWithName(.FrownO)
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(100)] as Dictionary!

        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No matches for this ingredient yet - add a match you enjoy!"
        return NSAttributedString(string: text, attributes: attributes)

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
        allCells = _allIngredients
        filteredCells = _allIngredients
        currentIngredient = nil

        self.navigationController?.navigationItem.title = TITLE_ALL_INGREDIENTS
        
        animateTableViewCellsToLeft(self.tableView)
    }
    
    func showIngredient(ingredient: PFObject) {
        currentIngredient = ingredient
        self.navigationController?.navigationItem.title = ingredient[_s_name] as? String   // Set navigation title to ingredient's name.
        
        allCells.removeAll()
        let matches = _getMatchesForIngredient(ingredient)
        
        for match in matches {
            allCells.append(match)
        }

        filteredCells = allCells                        // Reset 'filteredCells' with new matches.
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

        let match = filteredCells[indexPath.row]                    // Fetches the appropriate match to display.

        if currentIngredient != nil {
            cell.nameLabel.text = match[_s_matchName] as? String    // Set's the cell label to the ingredient's name.
            
            switch match[_s_matchLevel] as! Int {
            case 1:
                cell.backgroundColor = MATCH_LOW_COLOR              // match: low, white
            case 2:
                cell.backgroundColor = MATCH_MEDIUM_COLOR           // match: medium, yellow
            case 3:
                cell.backgroundColor = MATCH_HIGH_COLOR             // match: high, blue
            case 4:
                cell.backgroundColor = MATCH_GREATEST_COLOR         // match: greatest, green
            default:
                cell.backgroundColor = MATCH_LOW_COLOR
            }
            
            cell.leftButtons = [
                MGSwipeButton(title: "", icon: UIImage.fontAwesomeIconWithName(.HeartO, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30)), backgroundColor: editCellBtnColor, callback: {
                    (sender: MGSwipeTableCell!) -> Bool in
                    if currentUser != nil {
                    } else {
                        self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                    }
                    return true
                }),
                MGSwipeButton(title: "", icon: UIImage.fontAwesomeIconWithName(.Pencil, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30)), backgroundColor: editCellBtnColor, callback: {
                    (sender: MGSwipeTableCell!) -> Bool in
                    if currentUser != nil {
                    } else {
                        self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                    }
                    return true
                })
            ]
            cell.rightButtons = [
                MGSwipeButton(title: "", icon: UIImage.fontAwesomeIconWithName(.CaretUp, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30)), backgroundColor: upvoteCellBtnColor, callback: {
                    (sender: MGSwipeTableCell!) -> Bool in
                    if let user = currentUser {
                        downvoteMatch(user.objectId!, match: self.filteredCells[indexPath.row])
                    } else {
                        self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                    }
                    return true
                }),
                MGSwipeButton(title: "", icon: UIImage.fontAwesomeIconWithName(.CaretDown, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30)), backgroundColor: downvoteCellBtnColor, callback: {
                    (sender: MGSwipeTableCell!) -> Bool in
                    if let user = currentUser {
                        upvoteMatch(user.objectId!, match: self.filteredCells[indexPath.row])
                    } else {
                        self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                    }
                    return true
                })
            ]
            cell.leftSwipeSettings.transition = MGSwipeTransition.Rotate3D
            cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
        } else {
            cell.nameLabel.text = match[_s_name] as? String
            cell.backgroundColor = MATCH_LOW_COLOR
            cell.leftButtons = []
            cell.rightButtons = []
        }
        
        return cell
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        cell.leftButtons[index] = MGSwipeButton(title: "", icon: UIImage.fontAwesomeIconWithName(.HeartO, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30)), backgroundColor: editCellBtnColor)
        return false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let navi = self.navigationController as? MainNavigationController {
            if (navi.dropdownIsDown) {
                navi.dismissMenuTableView()
            } else {
                navi.pushToHistory()                                                      // Push current ingredient to history stack.

                tableView.contentOffset = CGPointMake(0, 0 - tableView.contentInset.top); // Reset scroll position.
                if currentIngredient != nil {
                    let match = filteredCells[indexPath.row]                              // Get tapped match.
                    let ingredient = _getIngredientForMatch(match)
                    showIngredient(ingredient!)
                } else {
                    let ingredient = filteredCells[indexPath.row]                         // Get tapped ingredient.
                    showIngredient(ingredient)
                }
                
                searchBarCancelButtonClicked(searchBar)
            }
        }
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
                if currentIngredient != nil {
                    if (ingredient[_s_matchName] as! String).rangeOfString(searchText.lowercaseString) != nil {
                        filteredCells.append(ingredient)
                    }
                } else {
                    if (ingredient[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
                        filteredCells.append(ingredient)
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
}
