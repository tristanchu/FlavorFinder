//
//  FavoritesPageController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import Parse
import UIKit

class FavoritesPageController: UITableViewController {

    // MARK: Properties:
    let favoriteCellName = "FavoriteTableViewCell"  // cell identifier
    var favoriteCells = [PFIngredient]()    // array of cells to display
    
    // Parse related:
    let ingredientColumn = "ingredient"
    let favoriteClassName = "Favorite"
    let userColumnName = "user"

    // Visual related:
    let noUserMsg = "You must be logged in to store favorites."
    let noFavoritesMsg =
        "Favorite ingredients in Search!"
    let favoritesTitle = "Favorites"
    let EMPTY_SET_TEXT_COLOR = UIColor(
        red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
    
    // Nav bar related:
    var addBtn: UIBarButtonItem = UIBarButtonItem()
    let addBtnAction : Selector = "addBtnClicked"
    let addBtnString = String.fontAwesomeIconWithName(.Plus) + "Add"
    
    // Segues:
    let segueToAddFav = "segueFavsToAddFav"

    // MARK: Override methods: ----------------------------------------------
    /* viewDidLoad:
            Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Connect table view to this controller (done in storyboard too)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: favoriteCellName)

        // Table view visuals:
        self.tableView.rowHeight = UNIFORM_ROW_HEIGHT
        self.tableView.tableFooterView = UIView(frame: CGRectZero) // remove empty cells
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.backgroundView = nil
        
        // Navigation visuals:
        setUpAddButton()
    }

    /* viewDidAppear:
            Setup when user goes into page.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Get navigation bar on top:
        var rightBtns : [UIBarButtonItem] = []
        if currentUser != nil {
            rightBtns.append(self.addBtn)
            self.addBtn.enabled = true
            self.tableView.backgroundColor = UIColor.whiteColor()
            self.tableView.backgroundView = nil
        }
        if let navi = self.tabBarController?.navigationController as?
                MainNavigationController {
            self.tabBarController?.navigationItem.setLeftBarButtonItems(
                    [], animated: true)
            self.tabBarController?.navigationItem.setRightBarButtonItems(
                rightBtns, animated: true)
            navi.reset_navigationBar()
            self.tabBarController?.navigationItem.title = favoritesTitle
        }

        // populate cell array
        populateFavoritesTable()

        // if nothing in cell array, display background message:
        if favoriteCells.isEmpty {
            // if user not logged in, needs to log in to store favs:
            if currentUser == nil {
                self.tableView.backgroundView =
                    emptyBackgroundTextFavorites(noUserMsg)
            // if user logged in, tell them how to have favs:
            } else {
                self.tableView.backgroundView =
                    emptyBackgroundTextFavorites(noFavoritesMsg)
            }
        }

        // update table view:
        self.tableView.reloadData();
    }

    /*  tableView -> int
            returns number of cells to display
    */
    override func tableView(
        tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteCells.count
    }


    /* tableView -> UITableViewCell
            creates cell for each index in favoriteCells
    */
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // set cell identifier:
        let cell = tableView.dequeueReusableCellWithIdentifier(
            favoriteCellName, forIndexPath: indexPath)
        // set cell label:
        cell.textLabel?.text = favoriteCells[indexPath.item].name
        return cell
    }

    /* tableView; Delete a cell:
    */
    override func tableView(tableView: UITableView,
                commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {

            // Tell parse to remove favorite from local db:
            unfavoriteIngredient(currentUser!,
                ingredient: self.favoriteCells[indexPath.row])

            // remove from display table:
            self.favoriteCells.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            // Show empty message if needed:
            if self.favoriteCells.isEmpty {
                self.tableView.backgroundView =
                    emptyBackgroundTextFavorites(noFavoritesMsg);
            }
        }
    }


    // MARK: Functions -------------------------------------------------
    
    /* populateFavoritesTable:
        clears current favorites array; gets user favorites from parse
        if user is logged in.
    */
    func populateFavoritesTable(){
        favoriteCells.removeAll()

        if ((currentUser) != nil) {
            // Get user favs from parse if logged in and show:
            let parseFavorites = getUserFavoritesFromLocal(currentUser!);
            if !parseFavorites.isEmpty {
                for fav in parseFavorites {
                    favoriteCells.append(fav[ingredientColumn] as! PFIngredient)
                }
            }
        }
    }

    /* emptyBackgroundText
        creates a backgroundView for when there is no data to display.
        text = text to display.
    */
    func emptyBackgroundTextFavorites(text: String) -> UILabel {
        let noDataLabel: UILabel = UILabel(frame: CGRectMake(
            0, 0, self.tableView.bounds.size.width,
            self.tableView.bounds.size.height))
        noDataLabel.text = text
        noDataLabel.textColor = EMPTY_SET_TEXT_COLOR
        noDataLabel.textAlignment = NSTextAlignment.Center
        return noDataLabel
    }
    
    /* setUpAddButton
        - sets up the add button visuals for navigation
    */
    func setUpAddButton() {
        addBtn.setTitleTextAttributes(attributes, forState: .Normal)
        addBtn.title = self.addBtnString
        addBtn.tintColor = NAVI_BUTTON_COLOR
        addBtn.target = self
        addBtn.action = self.addBtnAction
    }
    
    /* editBtnClicked
        - action for add button
    */
    func addBtnClicked() {
        self.performSegueWithIdentifier(segueToAddFav, sender: self)
    }


}
