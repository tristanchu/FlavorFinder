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
import FontAwesome_swift
import MGSwipeTableCell
import DZNEmptyDataSet
import DOFavoriteButton
import Darwin
import ASHorizontalScrollView

//                 filterGlobalSearchResults(searchText)


class SearchResultsSubviewController : UITableViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MGSwipeTableCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // CONSTANTS
    // numbers
    let K_CELL_HEIGHT : CGFloat = 40.0
    // color
    let EDIT_CELL_BTN_COLOR = UIColor(red: 249/255.0, green: 69/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
    let DOWNVOTE_CELL_BTN_COLOR = UIColor(red: 255/255.0, green: 109/255.0, blue: 69/255.0, alpha: CGFloat(0.3))
    let UPVOTE_CELL_BTN_COLOR = UIColor(red: 61/255.0, green: 235/255.0, blue: 64/255.0, alpha: CGFloat(0.3))
    let ADD_CELL_BTN_COLOR = UIColor(red: 161/255.0, green: 218/255.0, blue: 237/255.0, alpha: CGFloat(0.3))
    // cell images
    let UPVOTE_IMAGE = UIImage.fontAwesomeIconWithName(
        .ThumbsUp,
        textColor: MATCH_CELL_IMAGE_COLOR,
        size: MATCH_CELL_IMAGE_SIZE
    )
    let DOWNVOTE_IMAGE = UIImage.fontAwesomeIconWithName(
        .ThumbsDown,
        textColor: MATCH_CELL_IMAGE_COLOR,
        size: MATCH_CELL_IMAGE_SIZE
    )
    let FAVORITE_IMAGE = UIImage.fontAwesomeIconWithName(
        .Heart,
        textColor: MATCH_CELL_IMAGE_COLOR,
        size: MATCH_CELL_IMAGE_SIZE
    )
    let ADD_IMAGE = UIImage.fontAwesomeIconWithName(
        .Plus,
        textColor: MATCH_CELL_IMAGE_COLOR,
        size: MATCH_CELL_IMAGE_SIZE
    )

    // CLASS VARIABLES
    var allCells = [PFObject]()         // Array of all cells that CAN be displayed.
    var filteredCells = [PFObject]()    // Array of all cells that ARE displayed (filtered version of 'allCells').
    var currentIngredient : PFObject?   // Stores the ingredient being viewed (nil for all ingredients).
    
    var searchBarActivateBtn: UIBarButtonItem = UIBarButtonItem()
    var searchBar = UISearchBar()
    let notSignedInAlert = UIAlertController(title: "Not Signed In", message: "You need to sign in to do this!", preferredStyle: UIAlertControllerStyle.Alert)
    
    @IBOutlet var matchTableView: UITableView!
    
    var filterBtn: UIBarButtonItem = UIBarButtonItem()
    var filterView: ASHorizontalScrollView = ASHorizontalScrollView()
    var filterSearchBar = UISearchBar()
        
    let globalSearchTableView = UITableView()
    var globalSearchResults = [PFObject]()
        
    var hotpot = [PFObject]()
    
    var hotpotCollectionView : UICollectionView?
        
    let hotpotCollectionViewCellIdentifier = "hotpotCell"
        
    var filters: [String: Bool] = [F_KOSHER: false,
        F_DAIRY: false,
        F_VEG: false,
        F_NUTS: false]
        
    // SETUP FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
            
//        configure_searchBar()
//        configure_searchBarActivateBtn()
//        configure_filterBtn()
//        configure_filterView()
        configure_globalSearchTableView()
//        configure_hotpotCollectionView()
        
//        if let navi = self.tabBarController?.navigationController as? MainNavigationController {
//            notSignedInAlert.addAction(UIAlertAction(title: "Sign In", style: .Default, handler: { (action: UIAlertAction!)
//                in
//                let mainStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let loginViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier(LoginViewControllerIdentifier) as? LoginViewController
//                    navi.pushViewController(loginViewControllerObject!, animated: true)
//            }))
//            
//            notSignedInAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
//                    self.notSignedInAlert.dismissViewControllerAnimated(true, completion: nil)
//            }))
//        }
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tag = 1
            
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
            
        showAllIngredients()
        }
        
        override func viewDidAppear(animated: Bool) {
            if let navi = self.tabBarController?.navigationController as? MainNavigationController {
                self.tabBarController?.navigationItem.setLeftBarButtonItems([navi.goBackBtn, self.searchBarActivateBtn], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems([navi.goForwardBtn, navi.menuBarBtn, self.filterBtn], animated: true)
                navi.reset_navigationBar()
                navi.goBackBtn.enabled = false
                navi.goForwardBtn.enabled = false
            }
            
            if !hotpot.isEmpty {
                self.tableView.frame.offsetInPlace(dx: 0, dy: K_CELL_HEIGHT)
            }
            
            super.viewDidAppear(animated)
        }
        
        override func viewWillAppear(animated: Bool) {
            animateTableViewCellsToLeft(self.tableView)
        }
        
        func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
            let text = String.fontAwesomeIconWithName(.FrownO)
            let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(100)] as Dictionary!
            
            return NSAttributedString(string: text, attributes: attributes)
        }
        
        func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
            if let _ = currentIngredient {
                let text = "No matches for this ingredient yet - add a match you enjoy!"
                return NSAttributedString(string: text, attributes: attributes)
            } else {
                let text = "The ingredient you were looking for could not be found it - add it yourself!"
                return NSAttributedString(string: text, attributes: attributes)
            }
        }
        
//        func configure_searchBarActivateBtn() {
//            searchBarActivateBtn.setTitleTextAttributes(attributes, forState: .Normal)
//            searchBarActivateBtn.title = String.fontAwesomeIconWithName(.Search)
//            searchBarActivateBtn.tintColor = NAVI_BUTTON_COLOR
//            searchBarActivateBtn.target = self
//            searchBarActivateBtn.action = "searchBarActivateBtnClicked"
//        }
    
//        func configure_localSearchBar() {
//            searchBar.delegate = self
//            let y_offset = UIApplication.sharedApplication().statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height)!
//            let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
//            searchBar.frame = CGRect(x: 0, y: y_offset, width: screenWidth, height: 44)
//            self.tableView.tableHeaderView = self.searchBar
//        }
    
//        func configure_searchBar() {
//            searchBar.delegate = self
//            searchBar.hidden = true
//            searchBar.tag = 1
//            searchBar.setShowsCancelButton(true, animated: false)
//            let cancelButton = searchBar.valueForKey("cancelButton") as! UIButton
//            let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
//            UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: UIControlState.Normal)
//            cancelButton.setTitle(String.fontAwesomeIconWithName(.ChevronLeft), forState: UIControlState.Normal)
//            cancelButton.tintColor = NAVI_COLOR
//        }
    
//        func configure_filterBtn() {
//            filterBtn.setTitleTextAttributes(attributes, forState: .Normal)
//            filterBtn.title = String.fontAwesomeIconWithName(.Filter)
//            filterBtn.tintColor = NAVI_BUTTON_COLOR
//            filterBtn.target = self
//            filterBtn.action = "filterBtnClicked"
//        }
    
//        func configure_filterView() {
//            if let navi = self.navigationController as? MainNavigationController {
//                let y_offset = UIApplication.sharedApplication().statusBarFrame.size.height + navi.navigationBar.frame.height
//                filterView.frame = CGRectMake(0, y_offset, navi.navigationBar.frame.width, K_CELL_HEIGHT)
//                filterView.backgroundColor = NAVI_COLOR
//                filterView.hidden = true
//                
//                filterView.miniAppearPxOfLastItem = 10
//                filterView.uniformItemSize = CGSizeMake(80, 30)
//                // this must be called after changing any size or margin property of this class to get accurate margin
//                filterView.setItemsMarginOnce()
//                
//                let kosherBtn = UIButton()
//                kosherBtn.setTitle(F_KOSHER.capitalizedString, forState: .Normal)
//                kosherBtn.layer.cornerRadius = 10
//                kosherBtn.layer.borderWidth = 1
//                kosherBtn.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
//                kosherBtn.backgroundColor = UIColor.clearColor()
//                kosherBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(15)
//                kosherBtn.tag = 1
//                kosherBtn.addTarget(self, action: "filterToggleBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
//                filterView.addItem(kosherBtn)
//                
//                let dairyBtn = UIButton()
//                dairyBtn.setTitle(F_DAIRY.capitalizedString, forState: .Normal)
//                dairyBtn.layer.cornerRadius = 10
//                dairyBtn.layer.borderWidth = 1
//                dairyBtn.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
//                dairyBtn.backgroundColor = UIColor.clearColor()
//                dairyBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(15)
//                dairyBtn.tag = 2
//                dairyBtn.addTarget(self, action: "filterToggleBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
//                filterView.addItem(dairyBtn)
//                
//                let vegeBtn = UIButton()
//                vegeBtn.setTitle(F_VEG.capitalizedString, forState: .Normal)
//                vegeBtn.layer.cornerRadius = 10
//                vegeBtn.layer.borderWidth = 1
//                vegeBtn.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
//                vegeBtn.backgroundColor = UIColor.clearColor()
//                vegeBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(15)
//                vegeBtn.tag = 3
//                vegeBtn.addTarget(self, action: "filterToggleBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
//                filterView.addItem(vegeBtn)
//                
//                let nutsBtn = UIButton()
//                nutsBtn.setTitle(F_NUTS.capitalizedString, forState: .Normal)
//                nutsBtn.layer.cornerRadius = 10
//                nutsBtn.layer.borderWidth = 1
//                nutsBtn.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
//                nutsBtn.backgroundColor = UIColor.clearColor()
//                nutsBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(15)
//                nutsBtn.tag = 4
//                nutsBtn.addTarget(self, action: "filterToggleBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
//                filterView.addItem(nutsBtn)
//                
//                navi.view.addSubview(filterView)
//                //            self.view.addSubview(filterView)
//                //            let sbar = UISearchBar(frame: CGRectMake(0, y_offset+K_CELL_HEIGHT, navi.navigationBar.frame.width, K_CELL_HEIGHT))
//                filterSearchBar.frame = CGRectMake(0, y_offset+K_CELL_HEIGHT, navi.navigationBar.frame.width, K_CELL_HEIGHT)
//                filterSearchBar.layer.borderColor = NAVI_COLOR.CGColor
//                filterSearchBar.layer.borderWidth = 1
//                filterSearchBar.barTintColor = NAVI_COLOR
//                filterSearchBar.hidden = true
//                filterSearchBar.delegate = self
//                filterSearchBar.tag = 2
//                navi.view.addSubview(filterSearchBar)
//            }
//        }
    
        func configure_globalSearchTableView() {
            globalSearchTableView.hidden = true
            globalSearchTableView.tag = 2
            globalSearchTableView.delegate = self
            globalSearchTableView.dataSource = self
            globalSearchTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "globalSearchResultsCell")
            globalSearchTableView.tableFooterView = UIView();
            globalSearchTableView.layer.zPosition = 1
            let blurEffect = UIBlurEffect(style: .Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            globalSearchTableView.insertSubview(blurEffectView, atIndex: 0)
            //        globalSearchTableView.backgroundView = blurEffectView
            //if you want translucent vibrant table view separator lines
            //        globalSearchTableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
            if let navi = self.tabBarController?.navigationController as? MainNavigationController {
                let y_offset = UIApplication.sharedApplication().statusBarFrame.size.height + navi.navigationBar.frame.height
                globalSearchTableView.frame = CGRectMake(40, y_offset, navi.navigationBar.frame.width - 80, 0)
                navi.view.addSubview(globalSearchTableView)
            }
        }
        
//        func configure_hotpotCollectionView() {
//            if let navi = self.navigationController as? MainNavigationController {
//                let y_offset = UIApplication.sharedApplication().statusBarFrame.size.height + navi.navigationBar.frame.height
//                
//                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//                layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//                layout.itemSize = CGSize(width: 100, height: K_CELL_HEIGHT)
//                layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
//                let frame: CGRect = CGRectMake(0, y_offset, navi.navigationBar.frame.width, K_CELL_HEIGHT)
//                
//                hotpotCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
//                //            if let hotpotCollectionView = hotpotCollectionView {
//                hotpotCollectionView!.delegate = self
//                hotpotCollectionView!.dataSource = self
//                hotpotCollectionView!.registerClass(HotpotCollectionViewCell.self, forCellWithReuseIdentifier: hotpotCollectionViewCellIdentifier)
//                hotpotCollectionView!.backgroundColor = NAVI_COLOR
//                hotpotCollectionView!.hidden = true
//                navi.view.addSubview(hotpotCollectionView!)
//                hotpotCollectionView!.reloadData()
//                //            }
//            }
//        }
    
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
            let matches = _getMatchesForIngredient(ingredient, filters: filters)
            
            for match in matches {
                allCells.append(match)
            }
            
            //addToHotpot(ingredient)
            filteredCells = allCells                        // Reset 'filteredCells' with new matches.
            animateTableViewCellsToLeft(self.tableView)     // Show the new ingredients on our table with animation.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // COLLECTION
        func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return hotpot.count
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cellIdentifier = hotpotCollectionViewCellIdentifier
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! HotpotCollectionViewCell
            let ingredient = hotpot[indexPath.row]
            
            let name : NSString = ingredient[_s_name] as! NSString
            let size : CGSize = name.sizeWithAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(25)])
            //        cell.nameLabel = UILabel()
            cell.nameLabel.frame = CGRectMake(3, -3, size.width, size.height)
            cell.nameLabel.text = ingredient[_s_name] as? String
            cell.nameLabel.font = UIFont.fontAwesomeOfSize(25)
            cell.nameLabel.font = UIFont(name: "Avenir Next Bold", size: 16)
            cell.nameLabel.textColor = UIColor.whiteColor()
            //        cell.nameLabel.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 25, right: 0)
            cell.addSubview(cell.nameLabel)
            
            cell.removeBtn.frame = CGRectMake(cell.frame.width - 25, 0, 20, 20)
            cell.removeBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(20)
            cell.removeBtn.setTitle(String.fontAwesomeIconWithName(.Remove), forState: .Normal)
            cell.removeBtn.tintColor = NAVI_BUTTON_COLOR
            cell.removeBtn.addTarget(self, action: Selector("removeHotpotIngredientClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
            cell.removeBtn.ingredient = ingredient
            cell.addSubview(cell.removeBtn)
            //        cell.bringSubviewToFront(cell.removeBtn)
            
            cell.backgroundColor = NAVI_LIGHT_COLOR
            cell.layer.cornerRadius = 5
            
            return cell
        }
        
        func removeHotpotIngredientClicked(sender: RemoveHotpotIngredientButton) {
            hotpot.removeAtIndex(hotpot.indexOf(sender.ingredient!)!)
            hotpotCollectionView?.reloadData()
            
            if hotpot.isEmpty {
                hotpotCollectionView?.hidden = true
                self.tableView.frame.offsetInPlace(dx: 0, dy: -K_CELL_HEIGHT)
            }
        }
        
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let ingredient : PFObject = hotpot[indexPath.row]
            let name : NSString = ingredient[_s_name] as! NSString
            var size : CGSize = name.sizeWithAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(20)])
            size.width += 25
            return size
        }
        
        // TABLE FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // ---------------
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            // Return the number of sections.
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch tableView.tag {
            case 1:
                return filteredCells.count
            case 2:
                return globalSearchResults.count
            default:
                return filteredCells.count
            }
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            switch tableView.tag {
            case 1:
                let cellIdentifier = CELLIDENTIFIER_MATCH
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatchTableViewCell
                cell.delegate = self
                
                let match = filteredCells[indexPath.row]                    // Fetches the appropriate match to display.
                
                if currentIngredient != nil {
                    //            cell.nameLabel.text = match[_s_matchName] as? String    // Set's the cell label to the ingredient's name.
                    let matchObj = match[_s_secondIngredient] as! PFObject    // Set's the cell label to the ingredient's name.
                    cell.nameLabel.text = matchObj[_s_name] as? String
                    
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
//                    cell.nameLabel.text = match[_s_name] as? String
                    cell.backgroundColor = MATCH_LOW_COLOR
                }
                
                return cell
            case 2:
                let cellIdentifier = "globalSearchResultsCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
                
                cell.backgroundColor = UIColor.clearColor()
                
                let ingredient = globalSearchResults[indexPath.row]
                cell.textLabel?.text = ingredient[_s_name] as? String
                cell.textLabel!.font = UIFont.fontAwesomeOfSize(15)
                
                return cell
            default:
                return UITableViewCell()
            }
        }
        
        func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
            return true
        }
        
        func swipeTableCell(cell: MGSwipeTableCell!, didChangeSwipeState state: MGSwipeState, gestureIsActive: Bool) {
            
        }
        
        func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
            let indexPath = tableView.indexPathForCell(cell)!
            let match = filteredCells[indexPath.row]
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
                        self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
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
                        self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
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
                        self.presentViewController(self.notSignedInAlert, animated: true, completion: nil)
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
        
//        func addToHotpot(ingredient: PFObject) {
//            if !hotpot.contains(ingredient) {
//                if hotpot.isEmpty {
//                    hotpotCollectionView?.hidden = false
//                    self.tableView.frame.offsetInPlace(dx: 0, dy: K_CELL_HEIGHT)
//                }
//                
//                hotpot.append(ingredient)
//                hotpotCollectionView?.reloadData()
//            }
//        }
    
        func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
            
            if currentIngredient != nil {
                let indexPath = tableView.indexPathForCell(cell)!
                let match = filteredCells[indexPath.row]
                let ingredient = match[_s_secondIngredient] as! PFObject
                
                swipeSettings.transition = MGSwipeTransition.Drag
                
                switch direction {
                case MGSwipeDirection.RightToLeft:
                    return []
                case MGSwipeDirection.LeftToRight:
                    let addBtn = DOFavoriteButton(frame: CGRectMake(0, 0, 50, 50), image: ADD_IMAGE)
                    addBtn.imageColorOff = UIColor.grayColor()
                    addBtn.imageColorOn = UIColor.redColor()
                    addBtn.backgroundColor = ADD_CELL_BTN_COLOR
                    
                    let favBtn = DOFavoriteButton(frame: CGRectMake(0, 0, 50, 50), image: FAVORITE_IMAGE)
                    favBtn.imageColorOff = UIColor.grayColor()
                    favBtn.imageColorOn = UIColor.redColor()
                    favBtn.backgroundColor = EDIT_CELL_BTN_COLOR
                    
                    if let user = currentUser {
                        if let _ = isFavoriteIngredient(user, ingredient: ingredient) {
                            favBtn.selected = true
                        } else {
                            favBtn.selected = false
                        }
                    } else {
                        favBtn.selected = false
                    }
                    
                    let upvoteBtn = DOFavoriteButton(frame: CGRectMake(0, 0, 50, 50), image: UPVOTE_IMAGE)
                    upvoteBtn.imageColorOff = UIColor.grayColor()
                    upvoteBtn.imageColorOn = UIColor.blackColor()
                    upvoteBtn.backgroundColor = UPVOTE_CELL_BTN_COLOR
                    
                    let downvoteBtn = DOFavoriteButton(frame: CGRectMake(0, 0, 50, 50), image: DOWNVOTE_IMAGE)
                    downvoteBtn.imageColorOff = UIColor.grayColor()
                    downvoteBtn.imageColorOn = UIColor.blackColor()
                    downvoteBtn.backgroundColor = DOWNVOTE_CELL_BTN_COLOR
                    
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
            } else {
                return []
            }
        }
        
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            switch tableView.tag {
            case 1:
                if let navi = self.navigationController as? MainNavigationController {
                    if (navi.dropdownIsDown) {
                        navi.dismissMenuTableView()
                    } else {
                        navi.pushToHistory()                                                      // Push current ingredient to history stack.
                        
                        tableView.contentOffset = CGPointMake(0, 0 - tableView.contentInset.top); // Reset scroll position.
                        if currentIngredient != nil {
                            let match = filteredCells[indexPath.row]                              // Get tapped match.
                            //                    let ingredient = _getIngredientForMatch(match)
                            let ingredient = match[_s_secondIngredient] as! PFObject
                            showIngredient(ingredient)
                        } else {
                            let ingredient = filteredCells[indexPath.row]                         // Get tapped ingredient.
                            showIngredient(ingredient)
                        }
                        // DEBUGGED OUT
                        //searchBarCancelButtonClicked(searchBar)
                    }
                }
            case 2:
                let ingredient = globalSearchResults[indexPath.row]
                //DEBUGGED OUT
                //hideSearchBar()
                searchBar.text = ""
                showIngredient(ingredient)
            default:
                break;
            }
            
        }
        
        
        
        // SEARCHBAR FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // -------------------
//        func searchBarActivateBtnClicked() {
//            showSearchBar()
//        }
//        
//        func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//            hideSearchBar()
//            filterResults("")
//        }
//        
//        func showSearchBar() {
//            self.tabBarController?.navigationItem.titleView = searchBar
//            searchBar.alpha = 0
//            self.searchBar.hidden = false
//            if let navi = self.tabBarController?.navigationController as? MainNavigationController {
//                self.tabBarController?.navigationItem.setLeftBarButtonItems([navi.goBackBtn], animated: true)
//            }
//            
//            UIView.animateWithDuration(0.5, animations: {
//                self.searchBar.alpha = 1
//                }, completion: { finished in
//                    self.searchBar.becomeFirstResponder()
//            })
//            globalSearchTableView.hidden = false
//            if let navi = self.tabBarController?.navigationController as? MainNavigationController {
//                let y_offset = UIApplication.sharedApplication().statusBarFrame.size.height + navi.navigationBar.frame.height
//                globalSearchTableView.frame = CGRectMake(0, y_offset, navi.navigationBar.frame.width, 0)
//            }
//        }
    
//        func hideSearchBar() {
//            if let navi = self.tabBarController?.navigationController as? MainNavigationController {
//                var newTitle = ""
//                if let curr = currentIngredient {
//                    newTitle = curr[_s_name] as! String
//                } else {
//                    newTitle = TITLE_ALL_INGREDIENTS
//                }
//                
//                self.searchBar.alpha = 1
//                UIView.animateWithDuration(0.3, animations: {
//                    self.searchBar.alpha = 0
//                    self.tabBarController?.navigationItem.title = newTitle
//                    
//                    self.tabBarController?.navigationItem.setLeftBarButtonItems([navi.goBackBtn, self.searchBarActivateBtn], animated: true)
//                    
//                    }, completion: { finished in
//                        self.tabBarController?.navigationItem.titleView = nil
//                })
//            }
//            globalSearchTableView.hidden = true
//        }
//        
//        func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//            switch searchBar.tag {
//            case 1:
//                filterGlobalSearchResults(searchText)
//                break
//            case 2:
//                filterResults(searchText)
//                break
//            default:
//                break
//            }
//        }
    
        func filterGlobalSearchResults(searchText: String) {
            globalSearchResults.removeAll()
            
            if searchText.isEmpty {
                globalSearchResults = []
                searchBar.text = ""
            } else {
                for ingredient in _allIngredients {
                    if (ingredient[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
                        globalSearchResults.append(ingredient)
                    }
                }
            }
            if let navi = self.navigationController as? MainNavigationController {
                let y_offset = UIApplication.sharedApplication().statusBarFrame.size.height + navi.navigationBar.frame.height
                if globalSearchResults.count > 5 {
                    UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                        self.globalSearchTableView.frame = CGRectMake(0, y_offset, navi.navigationBar.frame.width, 5*self.K_CELL_HEIGHT)
                        }, completion: nil)
                } else {
                    UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                        self.globalSearchTableView.frame = CGRectMake(0, y_offset, navi.navigationBar.frame.width, CGFloat(self.globalSearchResults.count)*self.K_CELL_HEIGHT)
                        }, completion: nil)
                }
            }
            
            globalSearchTableView.reloadData()
        }
        
        func filterResults(searchText: String) {
            filteredCells.removeAll()
            
            if searchText.isEmpty {
                filteredCells = allCells
                searchBar.text = ""
            } else {
                for cell in allCells {
                    if currentIngredient != nil {
                        let secondIngredient = cell[_s_secondIngredient] as! PFObject
                        if (secondIngredient[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
                            filteredCells.append(cell)
                        }
                    } else {
                        if (cell[_s_name] as! String).rangeOfString(searchText.lowercaseString) != nil {
                            filteredCells.append(cell)
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
        }
        
        // FILTER FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // ----------------
//        func filterBtnClicked() {
//            print("filterBtn has been clicked.")
//            if (filterView.hidden) {
//                filterView.hidden = false
//                filterSearchBar.hidden = false
//                self.tableView.frame.offsetInPlace(dx: 0, dy: K_CELL_HEIGHT*2)
//                hotpotCollectionView!.frame.offsetInPlace(dx: 0, dy: K_CELL_HEIGHT*2)
//            } else {
//                filterView.hidden = true
//                filterSearchBar.hidden = true
//                self.tableView.frame.offsetInPlace(dx: 0, dy: -K_CELL_HEIGHT*2)
//                hotpotCollectionView!.frame.offsetInPlace(dx: 0, dy: -K_CELL_HEIGHT*2)
//            }
//        }
//    
//        func filterToggleBtnClicked(sender: UIButton) {
//            switch sender.tag {
//            case 1:
//                if filters[F_KOSHER]! {
//                    filters[F_KOSHER] = false
//                    sender.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
//                    sender.backgroundColor = UIColor.clearColor()
//                } else {
//                    filters[F_KOSHER] = true
//                    sender.backgroundColor = NAVI_BUTTON_COLOR
//                }
//                break
//            case 2:
//                if filters[F_DAIRY]! {
//                    filters[F_DAIRY] = false
//                    sender.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
//                    sender.backgroundColor = UIColor.clearColor()
//                } else {
//                    filters[F_DAIRY] = true
//                    sender.backgroundColor = NAVI_BUTTON_COLOR
//                }
//                break
//            case 3:
//                if filters[F_VEG]! {
//                    filters[F_VEG] = false
//                    sender.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
//                    sender.backgroundColor = UIColor.clearColor()
//                } else {
//                    filters[F_VEG] = true
//                    sender.backgroundColor = NAVI_BUTTON_COLOR
//                }
//                break
//            case 4:
//                if filters[F_NUTS]! {
//                    filters[F_NUTS] = false
//                    sender.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
//                    sender.backgroundColor = UIColor.clearColor()
//                } else {
//                    filters[F_NUTS] = true
//                    sender.backgroundColor = NAVI_BUTTON_COLOR
//                }
//                break
//            default:
//                break
//            }
//            
//            if let ingredient = currentIngredient {
//                showIngredient(ingredient)
//            }
//        }
}