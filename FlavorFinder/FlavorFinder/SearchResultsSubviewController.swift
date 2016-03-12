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
    let ADD_TO_SEARCH_IMAGE = UIImage.fontAwesomeIconWithName(
        .Plus,
        textColor: MATCH_CELL_IMAGE_COLOR,
        size: MATCH_CELL_IMAGE_SIZE
    )
    let ADD_TO_LIST_IMAGE = UIImage(named: "AddToList")!
    
    // strings
    let CELL_IDENTIFIER = "globalSearchResultsCell"
    
    // fonts
    let ICON_FONT = UIFont.fontAwesomeOfSize(100)

    // CLASS VARIABLES
    var matches = [(ingredient: PFIngredient, rank: Double)]() // data for the table
    var allMatches = [(ingredient: PFIngredient, rank: Double)]()
    
    var filters: [String: Bool] = [F_KOSHER: false,
        F_DAIRY: false,
        F_VEG: false,
        F_NUTS: false]
    
    // MARK: Actions
    // SETUP FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getSearchResults()
    }
    
    /* configureTableView
    - configures the visuals for the search results table
    */
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
        
        tableView.tableFooterView = UIView(frame: CGRectZero)  // remove empty cells
        tableView.backgroundColor = BACKGROUND_COLOR
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
        - does nothing if not logged in
    */
    func pinFavorites() {
        if isUserLoggedIn() {
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
        cell.icons.removeAll()
        
        if !(matches.isEmpty) {
            
            let match = matches[indexPath.row].ingredient

            if match.isDataAvailable() {
                let name = match[_s_name] as? String
                var upvotes = match[_s_upvotes] as? Int
                var downvotes = match[_s_downvotes] as? Int
                upvotes = upvotes == nil ? 0 : upvotes
                downvotes = downvotes == nil ? 0 : downvotes
                
                // !! quick fix for demo to avoid crashes, need to revisit filters in database
                
                let isNuts1 = match[_s_nuts] as? Bool
                let isDairy1 = match[_s_dairy] as? Bool
                let isVege1 = match[_s_vegetarian] as? Bool
                
                let isNuts2 = match["isNuts"] as? Bool
                let isDairy2 = match["isDairy"] as? Bool
                let isVege2 = match["isVege"] as? Bool
                
                var isFavorite = false
                if let user = currentUser {
                    if let _ = isFavoriteIngredient(user, ingredient: match) {
                        isFavorite = true
                    }
                }
                
                if (isVege1 != nil && isVege1!) || (isVege2 != nil && isVege2!) {
                    let imageVegan = UIImage(named: "Vegetarian")!
                    cell.icons.append(imageVegan)
                }
                if (isNuts1 != nil && isNuts1!) || (isNuts2 != nil && isNuts2!) {
                    let imageNuts = UIImage(named: "Nuts")!
                    cell.icons.append(imageNuts)
                }
                if (isDairy1 != nil && isDairy1!) || (isDairy2 != nil && isDairy2!) {
                    let imageDairy = UIImage(named: "Dairy")!
                    cell.icons.append(imageDairy)
                }
                if isFavorite {
                    let imageFav = UIImage(named: "Heart")!
                    cell.icons.append(imageFav)
                }

                cell.label.text = name
                cell.ingredientIcons.reloadData()
            } else {
                print("ERROR: Failed to fetch all data for match.")
                matches.removeAtIndex(indexPath.row)
                tableView.reloadData()
                cell.ingredientIcons.reloadData()
                return cell
            }
            
            if isUserLoggedIn() {
                cell.backgroundColor = SEARCH_RESULTS_CELL_COLOR
            }
        }
        
        return cell
    }
        
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, didChangeSwipeState state: MGSwipeState, gestureIsActive: Bool) {}
        
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        
        // Exit gracefully if this swipe isn't what we want
        
        if direction == MGSwipeDirection.RightToLeft {
            return true
        }
        
        let indexPath = tableView.indexPathForCell(cell)!
        let matchIngredient = matches[indexPath.row].ingredient
        
        if cell.leftButtons == nil || cell.leftButtons.isEmpty {
            print("ERROR: No buttons in search results cell button array.")
            return true
        }
        
        // Respond to cell button interactions
        
        let selBtn = cell.leftButtons[index] as! DOFavoriteButton
        // get upvote/downvote btns since btns reflect most recent vote & you can change vote
        let upvoteBtn = cell.leftButtons[0] as! DOFavoriteButton
        let downvoteBtn = cell.leftButtons[1] as! DOFavoriteButton
        
        switch index {
        case 0: // Upvote action
            if let user = currentUser { // in which case, buttons reflect whether voted (faster than re-searching)
                if selBtn.selected { // already upvoted, so you're canceling your vote
                    selBtn.deselect()
                    unvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient, voteType: _s_upvotes)
                } else if downvoteBtn.selected { // already downvoted, so change vote
                    downvoteBtn.deselect()
                    selBtn.select()
                    unvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient, voteType: _s_downvotes)
                    upvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient)
                    // Toast message:
                    self.parentViewController?.view.makeToast(voteFeedbackMsg(matchIngredient, upvote: true), duration: TOAST_DURATION, position: .Bottom)
                } else { // first-time vote
                    selBtn.select()
                    upvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient)
                    // Toast message:
                    self.parentViewController?.view.makeToast(voteFeedbackMsg(matchIngredient, upvote: true), duration: TOAST_DURATION, position: .Bottom)
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
                if selBtn.selected { // already downvoted, so cancel vote
                    selBtn.deselect()
                    unvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient, voteType: _s_downvotes)
                } else if upvoteBtn.selected { // already upvoted, so change vote
                    upvoteBtn.deselect()
                    selBtn.select()
                    unvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient, voteType: _s_upvotes)
                    downvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient)
                    // Toast message
                    self.parentViewController?.view.makeToast(voteFeedbackMsg(matchIngredient, upvote: false), duration: TOAST_DURATION, position: .Bottom)
                } else { // first-time vote
                    selBtn.select()
                    downvoteHotpot(user, hotpot: currentSearch, matchIngredient: matchIngredient)
                    // Toast message
                    self.parentViewController?.view.makeToast(voteFeedbackMsg(matchIngredient, upvote: false), duration: TOAST_DURATION, position: .Bottom)
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
                    
                    // need fav indicators!
                    
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
        case 4: // Add ingredient to list action
            if let _ = currentUser {
                if let parent = parentViewController as? SearchResultsViewController {
                    currentIngredientToAdd.append(matchIngredient)
                    parent.addToListBtnClicked()
                }
                return true
            } else {
                if let parent = parentViewController as? SearchResultsViewController {
                    parent.mustBeSignedIn()
                }
                return true
            }

        default:
            return true
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

        
        let favBtn = makeCellButton(FAV_IMAGE, backgroundColor: FAV_CELL_BTN_COLOR)
        let upvoteBtn = makeCellButton(UPVOTE_IMAGE, backgroundColor: UPVOTE_CELL_BTN_COLOR)
        let downvoteBtn = makeCellButton(DOWNVOTE_IMAGE, backgroundColor: DOWNVOTE_CELL_BTN_COLOR)
        let addToSearchBtn = makeCellButton(ADD_TO_SEARCH_IMAGE, backgroundColor: ADD_TO_SEARCH_CELL_BTN_COLOR)
        let addToListBtn = makeCellButton(ADD_TO_LIST_IMAGE, backgroundColor: ADD_TO_LIST_CELL_BTN_COLOR)
        
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
        
        return [upvoteBtn, downvoteBtn, favBtn, addToSearchBtn, addToListBtn]
    }
    
    /* tableView - cell selected override method
    - handles cell selection (via tap)
    - programmatically triggers swipe to reveal cell buttons
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? MGSwipeTableCell
        cell?.showSwipe(MGSwipeDirection.LeftToRight, animated: true) // cell buttons appear as if swiped
    }
        
    func filterResults(searchText: String) {
        matches.removeAll()
        
        if searchText.isEmpty {
//            matches = allMatches
            for match in allMatches {
                if ingredientPassesFilter(match.ingredient) {
                    matches.append(match)
                }
            }
        } else {
            for match in allMatches {
                if (match.ingredient[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
                    if ingredientPassesFilter(match.ingredient) {
                        matches.append(match)   
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    func ingredientPassesFilter(ingredient: PFIngredient) -> Bool {
        
        // need to revisit our filters in database, but quick fix for demo to prevent crashes
        
        var isDairy = ingredient[_s_dairy] as? Bool
        if isDairy == nil {
            isDairy = ingredient["isDairy"] as? Bool
        }
        var isNuts = ingredient[_s_nuts] as? Bool
        if isNuts == nil {
            isNuts = ingredient["isNuts"] as? Bool
        }
        var isVege = ingredient[_s_vegetarian] as? Bool
        if isVege == nil {
            isVege = ingredient["isVege"] as? Bool
        }
        
        if isDairy == nil || isNuts == nil || isVege == nil {
            return true
        }
        
        if filters[F_DAIRY]! && isDairy! || filters[F_NUTS]! && isNuts! || filters[F_VEG]! && !isVege! {
            return false
        } else {
            return true
        }
    }
    
    func filterButtonWasToggled(filters: [String:Bool], searchText: String) {
        self.filters = filters
        
        filterResults(searchText)
    }
    
    // Toast message ----------------------------------------------------
    /* upvoteFeedbackMsg
    */
    func voteFeedbackMsg(matchIngredient : PFIngredient, upvote : Bool) -> String {
        let matchName = matchIngredient.name
        let searchNames: [String] = currentSearch.map { return $0.name }
        let searchString = searchNames.joinWithSeparator(", ")
        if upvote {
            return "Upvoted \(matchName) with \(searchString)"
        } else {
            return "Downvoted \(matchName) with \(searchString)"
        }
    }
    
    
}