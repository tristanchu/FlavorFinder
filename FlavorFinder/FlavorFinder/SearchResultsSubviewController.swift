//
//  SearchResultsSubviewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/29/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MGSwipeTableCell
import DZNEmptyDataSet
import DOFavoriteButton
import Darwin
import ASHorizontalScrollView

class SearchResultsSubviewController : UITableViewController, MGSwipeTableCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // CONSTANTS
    // numbers
    let K_CELL_HEIGHT : CGFloat = 40.0
    let CELL_BTN_FRAME = CGRectMake(0, 0, 50, 50)
    // color
    let FAV_CELL_BTN_COLOR = UIColor(red: 249/255.0, green: 69/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
    let DOWNVOTE_CELL_BTN_COLOR = UIColor(red: 255/255.0, green: 109/255.0, blue: 69/255.0, alpha: CGFloat(0.3))
    let UPVOTE_CELL_BTN_COLOR = UIColor(red: 61/255.0, green: 235/255.0, blue: 64/255.0, alpha: CGFloat(0.3))
    let ADD_CELL_BTN_COLOR = UIColor(red: 161/255.0, green: 218/255.0, blue: 237/255.0, alpha: CGFloat(0.3))
    // cell images
    let UPVOTE_IMAGE = UIImage.fontAwesomeIconWithName(
        .ArrowUp,
        textColor: MATCH_CELL_IMAGE_COLOR,
        size: MATCH_CELL_IMAGE_SIZE
    )
    let DOWNVOTE_IMAGE = UIImage.fontAwesomeIconWithName(
        .ArrowDown,
        textColor: MATCH_CELL_IMAGE_COLOR,
        size: MATCH_CELL_IMAGE_SIZE
    )
    let FAV_IMAGE = UIImage.fontAwesomeIconWithName(
        .Heart,
        textColor: MATCH_CELL_IMAGE_COLOR,
        size: MATCH_CELL_IMAGE_SIZE
    )
    let ADD_IMAGE = UIImage.fontAwesomeIconWithName(
        .Plus,
        textColor: MATCH_CELL_IMAGE_COLOR,
        size: MATCH_CELL_IMAGE_SIZE
    )
    // strings
    let CELL_IDENTIFIER = "globalSearchResultsCell"
    // colors
    let CELL_BTN_OFF_COLOR = UIColor.grayColor()
    let CELL_BTN_ON_COLOR = UIColor.blackColor()
    // fonts
    let ICON_FONT = UIFont.fontAwesomeOfSize(100)

    // CLASS VARIABLES
    var allCells = [PFObject]()         // Array of all cells that CAN be displayed
    var displayedCells = [PFObject]()   // Array of all cells that ARE displayed (filtered)
    var currentIngredient : PFObject?   // Stores the ingredient being viewed
    
//    let notSignedInAlert = UIAlertController(title: "Not Signed In", message: "You need to sign in to do this!", preferredStyle: UIAlertControllerStyle.Alert)
    
    @IBOutlet var matchTableView: UITableView!
        
    let searchResultsTableView = UITableView()
    var globalSearchResults = [PFObject]()
    
    let filters: [String: Bool] = [F_KOSHER: false,
        F_DAIRY: false,
        F_VEG: false,
        F_NUTS: false]
    
    // SETUP FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        configure_searchResultsTableView()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tag = 1
            
        // Remove the cell separators
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        showAllIngredients()
    }
        
    override func viewWillAppear(animated: Bool) {
        animateTableViewCellsToLeft(self.tableView)
    }
        
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let icon = String.fontAwesomeIconWithName(.FrownO)
        let attributes = [NSFontAttributeName: ICON_FONT] as Dictionary!
        
        return NSAttributedString(string: icon, attributes: attributes)
    }
        
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        var text = SEARCH_GENERIC_ERROR_TEXT
        if let _ = currentIngredient {
            text = NO_MATCHES_TEXT
        } else {
            text = INGREDIENT_NOT_FOUND_TEXT
        }
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func configure_searchResultsTableView() {
        searchResultsTableView.hidden = true
        searchResultsTableView.tag = 2
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        searchResultsTableView.layer.zPosition = 1
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        searchResultsTableView.insertSubview(blurEffectView, atIndex: 0)
        searchResultsTableView.backgroundView = blurEffectView
    }
    
    func showAllIngredients() {
        allCells = _allIngredients
        displayedCells = _allIngredients
        currentIngredient = nil
        
        animateTableViewCellsToLeft(self.tableView)
    }
        
    func showIngredient(ingredient: PFObject) {
        currentIngredient = ingredient
        self.navigationController?.navigationItem.title = ingredient[_s_name] as? String   // Set navigation title to ingredient's name.
            
        allCells.removeAll()
        let matches = _getMatchesForIngredient(ingredient, filters: filters)
            
        for match in matches {
            allCells.append(match)
        }
            
        // Reset displayed cells
        displayedCells = allCells
        animateTableViewCellsToLeft(self.tableView)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TABLE FUNCTIONS
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
        
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCells.count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = CELLIDENTIFIER_MATCH
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatchTableViewCell
        cell.delegate = self
                
        let match = displayedCells[indexPath.row]
                
        if currentIngredient != nil {
            let matchObj = match[_s_secondIngredient] as! PFObject
            cell.label.text = matchObj[_s_name] as? String
            
            let matchLevel = match[_s_matchLevel] as! Int
            if matchLevel < MATCH_COLORS.count && matchLevel >= 0 {
                cell.backgroundColor = MATCH_COLORS[matchLevel]
            }
        } else {
            cell.label.text = match[_s_name] as? String
            cell.backgroundColor = MATCH_COLORS[0]
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
        let match = displayedCells[indexPath.row]
        let ingredient = match[_s_secondIngredient] as! PFObject
            
        switch direction {
        case MGSwipeDirection.RightToLeft:
            return true
        case MGSwipeDirection.LeftToRight:
            let btn = cell.leftButtons[index] as! DOFavoriteButton
                
            switch index {
            case 0:
                // Upvote action
                if let user = currentUser {
                    if let vote = hasVoted(user, match: match) {
                        let voteType = vote[_s_voteType] as! String
                            
                        if voteType == _s_upvotes {
                            // Already upvoted
                            unvoteMatch(user, match: match, voteType: _s_upvotes)
                            btn.deselect()
                        } else if voteType == _s_downvotes {
                            // Already downvoted
                            unvoteMatch(user, match: match, voteType: _s_downvotes)
                            upvoteMatch(user, match: match)
                            (cell.rightButtons[1] as! DOFavoriteButton).deselect()
                            btn.select()
                        }
                    } else {
                        // Neither voted
                        upvoteMatch(user, match: match)
                        btn.select()
                    }
                    return false
                } else {
//                    self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                    return true
                }
            case 1:
                // Downvote action
                if let user = currentUser {
                    if let vote = hasVoted(user, match: match) {
                        let voteType = vote[_s_voteType] as! String
                            
                        if voteType == _s_downvotes {
                            // Already downvoted
                            unvoteMatch(user, match: match, voteType: _s_downvotes)
                            btn.deselect()
                        } else if voteType == _s_upvotes {
                            // Already upvoted
                            unvoteMatch(user, match: match, voteType: _s_upvotes)
                            downvoteMatch(user, match: match)
                            (cell.rightButtons[0] as! DOFavoriteButton).deselect()
                            btn.select()
                        }
                    } else {
                        // Neither voted
                        downvoteMatch(user, match: match)
                        btn.select()
                    }
                    
                    return false
                } else {
//                    self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                    return true
                }
            case 2:
                // Favorite action
                if let user = currentUser {
                    if let _ = isFavoriteIngredient(user, ingredient: ingredient) {
                        unfavoriteIngredient(user, ingredient: ingredient)
                        btn.deselect()
                    } else {
                        favoriteIngredient(user, ingredient: ingredient)
                        btn.select()
                    }
                        
                    return false
                } else {
//                    self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
                    return true
                }
            case 3:
                // Add action
                print("DEBUG: Add to hotpot!")
                //addToHotpot(ingredient)
                return true
            default:
                return true
            }
        }
    }
    
    func makeCellButton(image: UIImage, backgroundColor: UIColor) -> DOFavoriteButton {
        let button = DOFavoriteButton(frame: CELL_BTN_FRAME, image: image)
        button.imageColorOff = CELL_BTN_OFF_COLOR
        button.imageColorOn = CELL_BTN_ON_COLOR
        button.backgroundColor = backgroundColor
        return button
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        
        // check that search is underway and that we swiped right, otherwise ignore
        if currentIngredient == nil || direction != MGSwipeDirection.LeftToRight {
            return []
        }
        
        let indexPath = tableView.indexPathForCell(cell)!
        let match = displayedCells[indexPath.row]
        let ingredient = match[_s_secondIngredient] as! PFObject
        
        swipeSettings.transition = MGSwipeTransition.Drag

        let addBtn = makeCellButton(ADD_IMAGE, backgroundColor: ADD_CELL_BTN_COLOR)
        let favBtn = makeCellButton(FAV_IMAGE, backgroundColor: FAV_CELL_BTN_COLOR)
        let upvoteBtn = makeCellButton(UPVOTE_IMAGE, backgroundColor: UPVOTE_CELL_BTN_COLOR)
        let downvoteBtn = makeCellButton(DOWNVOTE_IMAGE, backgroundColor: DOWNVOTE_CELL_BTN_COLOR)
        
        if let user = currentUser {
            if let _ = isFavoriteIngredient(user, ingredient: ingredient) {
                favBtn.selected = true
            } else {
                favBtn.selected = false
            }
        } else {
            favBtn.selected = false
        }
                    
        if let user = currentUser {
            if let vote = hasVoted(user, match: match) {
                if vote[_s_voteType] as! String == _s_upvotes {
                    upvoteBtn.selected = true
                    downvoteBtn.selected = false
                } else if vote[_s_voteType] as! String == _s_downvotes {
                    upvoteBtn.selected = false
                    downvoteBtn.selected = true
                }
            } else {
                upvoteBtn.selected = false
                downvoteBtn.selected = false
            }
        } else {
            upvoteBtn.selected = false
            downvoteBtn.selected = false
        }
        
        return [upvoteBtn, downvoteBtn, favBtn, addBtn]
    }
        
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch tableView.tag {
        case 1:
            if let navi = self.navigationController as? MainNavigationController {
                if (navi.dropdownIsDown) {
                } else {
                    tableView.contentOffset = CGPointMake(0, 0 - tableView.contentInset.top); // Reset scroll position.
                    if currentIngredient != nil {
                        let match = displayedCells[indexPath.row]                              // Get tapped match.
                        let ingredient = match[_s_secondIngredient] as! PFObject
                            showIngredient(ingredient)
                    } else {
                        let ingredient = displayedCells[indexPath.row]                         // Get tapped ingredient.
                            showIngredient(ingredient)
                    }
                }
            }
        case 2:
            let ingredient = globalSearchResults[indexPath.row]
            showIngredient(ingredient)
        default:
            break;
        }
            
    }

    
    func filterGlobalSearchResults(searchText: String) {
        globalSearchResults.removeAll()
        
        if searchText.isEmpty {
            globalSearchResults = []
        } else {
            for ingredient in _allIngredients {
                if (ingredient[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
                    globalSearchResults.append(ingredient)
                }
            }
        }
        searchResultsTableView.reloadData()
    }
        
    func filterResults(searchText: String) {
        displayedCells.removeAll()
        
        if searchText.isEmpty {
            displayedCells = allCells
        } else {
            for cell in allCells {
                if currentIngredient != nil {
                    let secondIngredient = cell[_s_secondIngredient] as! PFObject
                    if (secondIngredient[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
                        displayedCells.append(cell)
                    }
                } else {
                    if (cell[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
                        displayedCells.append(cell)
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
}