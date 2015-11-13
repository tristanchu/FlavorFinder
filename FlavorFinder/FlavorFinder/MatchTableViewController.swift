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
    
    let upvoteEmptyImage = UIImage.fontAwesomeIconWithName(.ThumbsOUp, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
    let upvoteImage = UIImage.fontAwesomeIconWithName(.ThumbsUp, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
    let downvoteEmptyImage = UIImage.fontAwesomeIconWithName(.ThumbsODown, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
    let downvoteImage = UIImage.fontAwesomeIconWithName(.ThumbsDown, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
    let editImage = UIImage.fontAwesomeIconWithName(.Pencil, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
    let favoriteEmptyImage = UIImage.fontAwesomeIconWithName(.HeartO, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
    let favoriteImage = UIImage.fontAwesomeIconWithName(.Heart, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))

    
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
        cell.delegate = self
        
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
        } else {
            cell.nameLabel.text = match[_s_name] as? String
            cell.backgroundColor = MATCH_LOW_COLOR
        }
        
        return cell
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, didChangeSwipeState state: MGSwipeState, gestureIsActive: Bool) {
        
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        let indexPath = tableView.indexPathForCell(cell)!
        let match = filteredCells[indexPath.row]
        
        switch direction {
        case MGSwipeDirection.LeftToRight:
            let btn = cell.leftButtons[index] as! MGSwipeButton
            switch index {
            case 0:
                // Favorite action
                if let user = currentUser {
                    if let _ = isFavorite(user.objectId!, match: match) {
                        unfavoriteMatch(user.objectId!, match: match)
                        btn.setImage(favoriteEmptyImage, forState: UIControlState.Normal)
                    } else {
                        favoriteMatch(user.objectId!, match: match)
                        btn.setImage(favoriteImage, forState: UIControlState.Normal)
                    }

                    return false
                } else {
                    self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                    return true
                }
            case 1:
                // Edit action
                if currentUser != nil {
                } else {
                    self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                }
                return true
            default:
                return true
            }
        case MGSwipeDirection.RightToLeft:
            let btn = cell.rightButtons[index] as! MGSwipeButton

            switch index {
            case 0:
                // Upvote action
                if let user = currentUser {
                    if let vote = hasVoted(user.objectId!, match: match) {
                        let voteType = vote[_s_voteType] as! String
                        
                        if voteType == _s_upvotes {
                            // Already upvoted
                            unvoteMatch(_s_upvotes, userId: user.objectId!, match: match)
                            btn.setImage(upvoteEmptyImage, forState: UIControlState.Normal)
                        } else if voteType == _s_downvotes {
                            // Already downvoted
                            unvoteMatch(_s_downvotes, userId: user.objectId!, match: match)
                            upvoteMatch(user.objectId!, match: match)
                            (cell.rightButtons[1] as! MGSwipeButton).setImage(downvoteEmptyImage, forState: UIControlState.Normal)
                            btn.setImage(upvoteImage, forState: UIControlState.Normal)
                        }
                    } else {
                        // Neither voted
                        upvoteMatch(user.objectId!, match: match)
                        btn.setImage(upvoteImage, forState: UIControlState.Normal)
                    }
                    
                    return false
                } else {
                    self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                    return true
                }
            case 1:
                // Downvote action
                if let user = currentUser {
                    if let vote = hasVoted(user.objectId!, match: match) {
                        let voteType = vote[_s_voteType] as! String
                        
                        if voteType == _s_downvotes {
                            // Already downvoted
                            unvoteMatch(_s_downvotes, userId: user.objectId!, match: match)
                            btn.setImage(downvoteEmptyImage, forState: UIControlState.Normal)
                        } else if voteType == _s_upvotes {
                            // Already upvoted
                            unvoteMatch(_s_upvotes, userId: user.objectId!, match: match)
                            downvoteMatch(user.objectId!, match: match)
                            (cell.rightButtons[0] as! MGSwipeButton).setImage(upvoteEmptyImage, forState: UIControlState.Normal)
                            btn.setImage(downvoteImage, forState: UIControlState.Normal)
                        }
                    } else {
                        // Neither voted
                        downvoteMatch(user.objectId!, match: match)
                        btn.setImage(downvoteImage, forState: UIControlState.Normal)
                    }
                    
                    return false
                } else {
                    self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                    return true
                }
            default:
                return true
            }
        }
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        
        let indexPath = tableView.indexPathForCell(cell)!
        let match = filteredCells[indexPath.row]
        
        if currentIngredient != nil {
            swipeSettings.transition = MGSwipeTransition.Drag
            
            switch direction {
            case MGSwipeDirection.LeftToRight:
                var favBtn: MGSwipeButton?
                
                if let user = currentUser {
                    if let _ = isFavorite(user.objectId!, match: match) {
                        favBtn = MGSwipeButton(title: "", icon: favoriteImage, backgroundColor: editCellBtnColor)
                    } else {
                        favBtn = MGSwipeButton(title: "", icon: favoriteEmptyImage, backgroundColor: editCellBtnColor)
                    }
                } else {
                    favBtn = MGSwipeButton(title: "", icon: favoriteEmptyImage, backgroundColor: editCellBtnColor)
                }
                
                let editBtn = MGSwipeButton(title: "", icon: editImage, backgroundColor: editCellBtnColor)
                
                return [favBtn!, editBtn]
                
            case MGSwipeDirection.RightToLeft:
                var upvoteBtn: MGSwipeButton?
                var downvoteBtn: MGSwipeButton?
                
                if let user = currentUser {
                    if let vote = hasVoted(user.objectId!, match: match) {
                        if vote[_s_voteType] as! String == _s_upvotes {
                            upvoteBtn = MGSwipeButton(title: "", icon: upvoteImage, backgroundColor: upvoteCellBtnColor)
                            downvoteBtn = MGSwipeButton(title: "", icon: downvoteEmptyImage, backgroundColor: downvoteCellBtnColor)
                        } else if vote[_s_voteType] as! String == _s_downvotes {
                            upvoteBtn = MGSwipeButton(title: "", icon: upvoteEmptyImage, backgroundColor: upvoteCellBtnColor)
                            downvoteBtn = MGSwipeButton(title: "", icon: downvoteImage, backgroundColor: downvoteCellBtnColor)
                        }
                    } else {
                        upvoteBtn = MGSwipeButton(title: "", icon: upvoteEmptyImage, backgroundColor: upvoteCellBtnColor)
                        downvoteBtn = MGSwipeButton(title: "", icon: downvoteEmptyImage, backgroundColor: downvoteCellBtnColor)
                    }
                } else {
                    upvoteBtn = MGSwipeButton(title: "", icon: upvoteEmptyImage, backgroundColor: upvoteCellBtnColor)
                    downvoteBtn = MGSwipeButton(title: "", icon: downvoteEmptyImage, backgroundColor: downvoteCellBtnColor)
                }
                
                return [upvoteBtn!, downvoteBtn!]
            }
        } else {
            return []
        }
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
