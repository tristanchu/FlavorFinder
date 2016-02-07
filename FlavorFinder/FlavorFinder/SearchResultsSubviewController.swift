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

class SearchResultsSubviewController : UITableViewController, MGSwipeTableCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: Properties:
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
    var matches = [(ingredient: PFIngredient, rank: Double)]() // data for the table
    var allMatches = [(ingredient: PFIngredient, rank: Double)]()
    
    var maxMatchRank : Double = -1 // used to determine match color level...
    var matchAvg : Double = 0
    
    var filters: [String: Bool] = [F_KOSHER: false,
        F_DAIRY: false,
        F_VEG: false,
        F_NUTS: false]
 
    // MARK: Actions
    // SETUP FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        getSearchResults()
    }
        
    override func viewWillAppear(animated: Bool) {
        animateTableViewCellsToLeft(self.tableView)
    }
    
    // EMPTY DATA SET DISPLAY
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let icon = String.fontAwesomeIconWithName(.FrownO)
        let attributes = [NSFontAttributeName: ICON_FONT] as Dictionary!
        
        return NSAttributedString(string: icon, attributes: attributes)
    }
        
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        var text = SEARCH_GENERIC_ERROR_TEXT
        if currentSearch.isEmpty {
            text = SEARCH_GENERIC_ERROR_TEXT
        } else {
            text = MATCHES_NOT_FOUND_TEXT
        }
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        tableView.layer.zPosition = 1
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.insertSubview(blurEffectView, atIndex: 0)
        tableView.backgroundView = blurEffectView
        
        // Remove the cell separators
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    func getNewSearchResults() {
        allMatches = getMultiSearch(currentSearch)
        while !(isMatchDataLoaded()) {}
        allMatches = sortByRank(allMatches)
        matchAvg = 0
        maxMatchRank = -1
        for match in allMatches {
            matchAvg += match.rank
            if match.rank > maxMatchRank {
                maxMatchRank = match.rank
            }
        }
        matchAvg /= Double(allMatches.count)
        matches = allMatches
        animateTableViewCellsToLeft(tableView)
        tableView.reloadData()
    }
    
    func isMatchDataLoaded() -> Bool {
        for i in 0..<allMatches.count {
            if !(allMatches[i].ingredient.isDataAvailable()) {
                print("ERROR: Failed to fetch all data for match.")
                allMatches.removeAtIndex(i)
                return false
            }
        }
        return true
    }
    
    func getSearchResults() {
        if allMatches.isEmpty {
            getNewSearchResults()
        } else {
            allMatches = addToSearch(allMatches, newIngredient: currentSearch.last!)
            while !(isMatchDataLoaded()) {}
            matches = allMatches
            tableView.reloadData()
        }
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
        return matches.count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = CELLIDENTIFIER_MATCH
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatchTableViewCell
        cell.delegate = self
        
        if !(matches.isEmpty) {
            let match = matches[indexPath.row].ingredient
            let matchRank = matches[indexPath.row].rank // not in use for now
            let matchesPerLevel = Int(matches.count / MATCH_COLORS.count)
            let matchLevel = Int((matches.count - indexPath.row)/matchesPerLevel)

            if match.isDataAvailable() {
                cell.label.text = match[_s_name] as? String
            } else {
                print("ERROR: Failed to fetch all data for match.")
                matches.removeAtIndex(indexPath.row)
                tableView.reloadData()
                return cell
            }
            if matchLevel < MATCH_COLORS.count && matchLevel >= 0 {
                cell.backgroundColor = MATCH_COLORS[matchLevel]
            } else if matchLevel >= MATCH_COLORS.count {
                cell.backgroundColor = MATCH_COLORS.last
            } else {
                cell.backgroundColor = MATCH_COLORS[0] // default
            }
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
        let ingredient = matches[indexPath.row].ingredient
        //  re: voting -- got to get matches and decide what to do with multi-search
        //  disabling until we figure that out!
        // DEBUG: disabled voting feature for now
        
        if cell.leftButtons == nil || cell.leftButtons.isEmpty {
            print("ERROR: No buttons in search results cell button array.")
            return true
        }
            
        switch direction {
        case MGSwipeDirection.RightToLeft:
            return true
        case MGSwipeDirection.LeftToRight:
            let selBtn = cell.leftButtons[index] as! DOFavoriteButton
            let upvoteBtn = cell.leftButtons[0] as! DOFavoriteButton
            let downvoteBtn = cell.leftButtons[1] as! DOFavoriteButton
            
            switch index {
            case 0: // Upvote action
                break // DEBUG: disabling voting
//                if let user = currentUser {
//                    if let vote = hasVoted(user, match: match) {
//                        let voteType = vote[_s_voteType] as! String
//                            
//                        if voteType == _s_upvotes {
//                            // Already upvoted
//                            unvoteMatch(user, match: match, voteType: _s_upvotes)
//                            selBtn.deselect()
//                        } else if voteType == _s_downvotes {    // Already downvoted
//                            unvoteMatch(user, match: match, voteType: _s_downvotes)
//                            upvoteMatch(user, match: match)
//                            downvoteBtn.deselect()
//                            selBtn.select()
//                        }
//                    } else { // First-time vote
//                        upvoteMatch(user, match: match)
//                        selBtn.select()
//                    }
//                    return false
//                } else {
////                    self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
//                    return true
//                }
            case 1: // Downvote action
                break // DEBUG: disabling voting
//                if let user = currentUser {
//                    if let vote = hasVoted(user, match: match) {
//                        let voteType = vote[_s_voteType] as! String
//                            
//                        if voteType == _s_downvotes {
//                            // Already downvoted
//                            unvoteMatch(user, match: match, voteType: _s_downvotes)
//                            selBtn.deselect()
//                        } else if voteType == _s_upvotes {
//                            // Already upvoted
//                            unvoteMatch(user, match: match, voteType: _s_upvotes)
//                            downvoteMatch(user, match: match)
//                            
//                            upvoteBtn.deselect()
//                            selBtn.select()
//                        }
//                    } else { // First-time vote
//                        downvoteMatch(user, match: match)
//                        selBtn.select()
//                    }
//                    
//                    return false
//                } else {
////                    self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
//                    return true
//                }
            case 2: // Favorite action
                if let user = currentUser {
                    if let _ = isFavoriteIngredient(user, ingredient: ingredient) {
                        unfavoriteIngredient(user, ingredient: ingredient)
                        selBtn.deselect()
                    } else {
                        favoriteIngredient(user, ingredient: ingredient)
                        selBtn.select()
                    }
                    return false
                } else {
                    if let parent = parentViewController as? SearchResultsViewController {
                        parent.mustBeSignedIn()
                    return true
                    }
                }
            case 3: // Add-to-hotpot action
                currentSearch.append(ingredient)
                if let parent = parentViewController as? SearchResultsViewController {
                    parent.newSearchTermWasAdded()
                } else {
                    print("ERROR: Add to hotpot failed.")
                }
                return true
            default:
                return true
            }
        }
        return true
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
        if currentSearch.count < 0 || direction != MGSwipeDirection.LeftToRight {
            return []
        }
        
        let indexPath = tableView.indexPathForCell(cell)!
        let ingredient = matches[indexPath.row].ingredient
        
        swipeSettings.transition = MGSwipeTransition.Drag

        let addBtn = makeCellButton(ADD_IMAGE, backgroundColor: ADD_CELL_BTN_COLOR)
        let favBtn = makeCellButton(FAV_IMAGE, backgroundColor: FAV_CELL_BTN_COLOR)
        let upvoteBtn = makeCellButton(UPVOTE_IMAGE, backgroundColor: UPVOTE_CELL_BTN_COLOR)
        let downvoteBtn = makeCellButton(DOWNVOTE_IMAGE, backgroundColor: DOWNVOTE_CELL_BTN_COLOR)
        
        // if we're logged in, display user-ingredient history
        if let user = currentUser {
            
            // display whether or not user has favorited ingredient
            if let _ = isFavoriteIngredient(user, ingredient: ingredient) {
                favBtn.selected = true
            } else {
                favBtn.selected = false
            }
            
            // display whether or not user has voted on match
            if false { // DEBUG: voting disabled
//            if let vote = hasVoted(user, match: match) {
//                if vote[_s_voteType] as! String == _s_upvotes {
//                    upvoteBtn.selected = true
//                } else if vote[_s_voteType] as! String == _s_downvotes {
//                    upvoteBtn.selected = false
//                }
//                downvoteBtn.selected = !upvoteBtn.selected // can only vote one direction
            } else {
                upvoteBtn.selected = false
                downvoteBtn.selected = false
            }
            
            
        } else { // not logged in
            favBtn.selected = false
            upvoteBtn.selected = false
            downvoteBtn.selected = false
        }
        
        return [upvoteBtn, downvoteBtn, favBtn, addBtn]
    }
        
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
    }
    
//    func filterGlobalSearchResults(searchText: String) {
//        globalSearchResults.removeAll()
//        
//        if searchText.isEmpty {
//            globalSearchResults = []
//        } else {
//            for ingredient in _allIngredients {
//                if (ingredient[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
//                    globalSearchResults.append(ingredient)
//                }
//            }
//        }
//        searchResultsTableView.reloadData()
//    }
        
    func filterResults(searchText: String) {
        matches.removeAll()
        
        if searchText.isEmpty {
            matches = allMatches
        } else {
            for match in allMatches {
                if (match.ingredient[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
                    matches.append(match)
                }
            }
        }
        
        self.tableView.reloadData()
    }
}