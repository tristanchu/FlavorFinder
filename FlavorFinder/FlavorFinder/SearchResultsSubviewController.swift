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
        .SearchPlus,
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
    
    var filters: [String: Bool] = [F_KOSHER: false,
        F_DAIRY: false,
        F_VEG: false,
        F_NUTS: false]
 
    let clearSearchBtn = UIBarButtonItem()
    let addToListBtn = UIBarButtonItem()
    let optionsBtn = UIBarButtonItem()
    
    // MARK: Actions
    // SETUP FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        
        clearSearchBtn.setTitleTextAttributes(attributes, forState: .Normal)
        clearSearchBtn.title = String.fontAwesomeIconWithName(.ChevronLeft) + " New Search"
        clearSearchBtn.tintColor = NAVI_BUTTON_COLOR
        clearSearchBtn.target = self
        clearSearchBtn.action = "clearSearchBtnClicked"
        
        addToListBtn.setTitleTextAttributes(attributes, forState: .Normal)
        addToListBtn.title = String.fontAwesomeIconWithName(.Plus) + " Add to List"
        addToListBtn.tintColor = NAVI_BUTTON_COLOR
        addToListBtn.target = self
        addToListBtn.action = "addToListBtnClicked"
        
        optionsBtn.setTitleTextAttributes(attributes, forState: .Normal)
        optionsBtn.title = String.fontAwesomeIconWithName(.Bars)
        optionsBtn.tintColor = NAVI_BUTTON_COLOR
        optionsBtn.target = self
        optionsBtn.action = "addToListBtnClicked"
        
        getSearchResults()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup navigation bar
        if let navi = self.tabBarController?.navigationController as? MainNavigationController {
            self.tabBarController?.navigationItem.setLeftBarButtonItems([self.clearSearchBtn], animated: true)
            self.tabBarController?.navigationItem.setRightBarButtonItems([self.addToListBtn], animated: true)
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
    
    // EMPTY DATA SET DISPLAY
    
    /* titleForEmptyDataSet:
    - implementing DZNEmptyDataSetSource / DZNEmptyDataSetDelegate
    - table displays this large title text (for us, an icon) when no results
    */
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let icon = String.fontAwesomeIconWithName(.FrownO)
        let attributes = [NSFontAttributeName: ICON_FONT] as Dictionary!
        
        return NSAttributedString(string: icon, attributes: attributes)
    }
    
    /* descriptionForEmptyDataSet:
    - implementing DZNEmptyDataSetSource / DZNEmptyDataSetDelegate
    - table displays this text description when no results
    */
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        var text = SEARCH_GENERIC_ERROR_TEXT
        if currentSearch.isEmpty {
            text = SEARCH_GENERIC_ERROR_TEXT
        } else {
            text = MATCHES_NOT_FOUND_TEXT
        }
        return NSAttributedString(string: text, attributes: attributes)
    }

    /* clearSearchBtnClicked:
    - lets parent know that the user has cleared the search
    */
    func clearSearchBtnClicked() {
        if let parent = parentViewController as! SearchResultsViewController? {
            parent.clearSearch()
        }
    }
    
    /* addToListBtnClicked
        - presents modal view to then select a list
    */
    func addToListBtnClicked() {
        print("add to list button clicked")
        
    }
    
  // SEARCH RESULTS
    
    func getNewSearchResults() {
        allMatches = getMultiSearch(currentSearch)
        while !(isMatchDataLoaded()) {}
        allMatches = sortByRank(allMatches)
        pinFavorites()
        matches = allMatches
        animateTableViewCellsToLeft(tableView)
        tableView.reloadData()
    }
    
    /* isMatchDataLoaded
        - returns true if gets through allMatches with isDataAvailable for each ingredient
        - returns false if isDataAvailable call fails for any ingredient, first removing
            that ingredient from allMatches
    */
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
    
    /* getSearchResults
        - runs new search if allMatches is empty
        - adds to existing search if allMatches contains matches
    */
    func getSearchResults() {
        if allMatches.isEmpty {
            getNewSearchResults()
        } else {
            allMatches = addToSearch(allMatches, newIngredient: currentSearch.last!)
            while !(isMatchDataLoaded()) {}
            pinFavorites()
            matches = allMatches
            tableView.reloadData()
        }
    }
    
    /* pinFavorites
        - pins favorites to top of search results, in rank order with respect
            to each other assuming the results have already been sorted by rank
        - does nothing if currentUser == nil
    */
    func pinFavorites() {
        if (currentUser != nil) {
            var matchesWithPins = [(ingredient: PFIngredient, rank: Double)]()
            var insertFavIndex = 0
            for match in allMatches {
                if let _ = isFavoriteIngredient(currentUser!, ingredient: match.ingredient) {
                    matchesWithPins.insert(match, atIndex: insertFavIndex)
                    insertFavIndex++
                } else {
                    matchesWithPins.append(match)
                }
            }
            allMatches = matchesWithPins
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
    
    /* tableView:
    - formats appearance and assigns properties for a given cell
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = CELLIDENTIFIER_MATCH
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatchTableViewCell
        cell.delegate = self
        
        if !(matches.isEmpty) {
            let match = matches[indexPath.row].ingredient
            var matchesPerLevel = Int(matches.count / MATCH_COLORS.count)
            if matchesPerLevel == 0 { // no dividing by zero, please
                matchesPerLevel = 1
            }
            
            // for now, doing a simple match coloration based on equal proportions at each level
            let matchLevel = Int((matches.count - indexPath.row)/matchesPerLevel)

            if match.isDataAvailable() {
                let name = match[_s_name] as? String
                var upvotes = match[_s_upvotes] as? Int
                var downvotes = match[_s_downvotes] as? Int
                upvotes = upvotes == nil ? 0 : upvotes
                downvotes = downvotes == nil ? 0 : downvotes
                
                cell.label.text = name
                cell.upvoteLabel.text = "test"//String(upvotes)
                cell.downvoteLabel.text = String(downvotes)
            } else {
                print("ERROR: Failed to fetch all data for match.")
                matches.removeAtIndex(indexPath.row)
                tableView.reloadData()
                return cell
            }
            if currentUser != nil && isFavoriteIngredient(currentUser!, ingredient: match) != nil {
                cell.backgroundColor = FAV_PINNED_COLOR
            } else if matchLevel < MATCH_COLORS.count && matchLevel >= 0 {
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
        
    func swipeTableCell(cell: MGSwipeTableCell!, didChangeSwipeState state: MGSwipeState, gestureIsActive: Bool) {}
        
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        let indexPath = tableView.indexPathForCell(cell)!
        let matchIngredient = matches[indexPath.row].ingredient
        
        if cell.leftButtons == nil || cell.leftButtons.isEmpty {
            print("ERROR: No buttons in search results cell button array.")
            return true
        }
            
        switch direction {
        case MGSwipeDirection.RightToLeft:
            return true
        case MGSwipeDirection.LeftToRight:
            let selBtn = cell.leftButtons[index] as! DOFavoriteButton
            // get upvote/downvote btns since btns reflect most recent vote & you can change vote
            let upvoteBtn = cell.leftButtons[0] as! DOFavoriteButton
            let downvoteBtn = cell.leftButtons[1] as! DOFavoriteButton
            
            switch index {
            case 0: // Upvote action
                if let user = currentUser {
                    let voteType = getHotpotVoteType(user, hotpot: currentSearch, matchIngredient: matchIngredient)
                    if voteType == _s_upvotes {
                        // Already upvoted
                        selBtn.deselect()
                        unvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient, voteType: _s_upvotes)
                    } else if voteType == _s_downvotes {    // Already downvoted
                        downvoteBtn.deselect()
                        selBtn.select()
                        unvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient, voteType: _s_downvotes)
                        upvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient)
                    } else { // First-time vote
                        selBtn.select()
                        upvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient)
                    }
                    return false
                } else {
                    if let parent = parentViewController as? SearchResultsViewController {
                        parent.mustBeSignedIn()
                    }
                    return true
                }
            case 1: // Downvote action
                if let user = currentUser {
                    let voteType = getHotpotVoteType(user, hotpot: currentSearch, matchIngredient: matchIngredient)
                    if voteType == _s_downvotes {
                        // Already downvoted
                        selBtn.deselect()
                        unvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient, voteType: _s_downvotes)
                    } else if voteType == _s_upvotes {
                        // Already upvoted
                        upvoteBtn.deselect()
                        selBtn.select()
                        unvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient, voteType: _s_upvotes)
                        downvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient)
                    } else { // First-time vote
                        selBtn.select()
                        downvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient)
                    }
                    return false
                } else {
                    if let parent = parentViewController as? SearchResultsViewController {
                        parent.mustBeSignedIn()
                    }
                    return true
                }
            case 2: // Favorite action
                if let user = currentUser {
                    if let _ = isFavoriteIngredient(user, ingredient: matchIngredient) {
                        unfavoriteIngredient(user, ingredient: matchIngredient)
                        selBtn.deselect()
//                        getNewSearchResults()   // unpin fav
                        // note: unfavoriteIngredient is a slow-enough operation that
                        // cell would still look like "fav" if you simply reload table data,
                        // but getNewSearchResults (which pins) works but is too slow for
                        // effective feedback
                        cell.backgroundColor = MATCH_COLORS[0] // default color, instead of fav color
                    } else {
                        favoriteIngredient(user, ingredient: matchIngredient)
                        selBtn.select()
                        tableView.reloadData()  // changes cell appearance to "fav cell" look
                    }
                    return false
                } else {
                    if let parent = parentViewController as? SearchResultsViewController {
                        parent.mustBeSignedIn()
                    }
                    return true
                }
            case 3: // Add-to-hotpot action
                currentSearch.append(matchIngredient)
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
        let matchIngredient = matches[indexPath.row].ingredient
        
        swipeSettings.transition = MGSwipeTransition.Drag

        let addBtn = makeCellButton(ADD_IMAGE, backgroundColor: ADD_CELL_BTN_COLOR)
        let favBtn = makeCellButton(FAV_IMAGE, backgroundColor: FAV_CELL_BTN_COLOR)
        let upvoteBtn = makeCellButton(UPVOTE_IMAGE, backgroundColor: UPVOTE_CELL_BTN_COLOR)
        let downvoteBtn = makeCellButton(DOWNVOTE_IMAGE, backgroundColor: DOWNVOTE_CELL_BTN_COLOR)
        
        // if we're logged in, display user-ingredient history
        if let user = currentUser {
            
            // display whether or not user has favorited ingredient
            if let _ = isFavoriteIngredient(user, ingredient: matchIngredient) {
                favBtn.selected = true
            } else {
                favBtn.selected = false
            }
            
            // display whether or not user has voted on match
            let voteType = getHotpotVoteType(user, hotpot: currentSearch, matchIngredient: matchIngredient)
            if voteType == _s_upvotes {
                upvoteBtn.selected = true
                downvoteBtn.selected = false
            } else if voteType == _s_downvotes {
                upvoteBtn.selected = false
                downvoteBtn.selected = true
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
        
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}
        
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