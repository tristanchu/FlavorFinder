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

    @IBOutlet var favoritesTableView: UITableView!


    // MARK: Override methods: ----------------------------------------------
    /* viewDidLoad:
            Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Connect table view to this controller (done in storyboard too)
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: favoriteCellName)
    }

    /* viewDidAppear:
            Setup when user goes into page.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)


        // reload table view:
        populateFavoritesTable()
        favoritesTableView.reloadData()

    }

    /*  tableView -> int
            returns number of cells to display
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteCells.count
    }

    /* tableView -> UITableViewCell
            creates cell for each index in favoriteCells
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(favoriteCellName, forIndexPath: indexPath)
        cell.textLabel?.text = favoriteCells[indexPath.item].name
        return cell
    }


    // MARK: Functions -------------------------------------------------
    
    /* populateFavoritesTable:
        clears current favorites array; gets user favorites from parse
        if user is logged in.
    
        TODO: Make a cache of user favs that we update when they log in,
            favorite, or delete something to limit parse calls.
    */
    func populateFavoritesTable(){
        favoriteCells.removeAll()

        if (currentUser != nil) {
            // Get user favs from parse if logged in and show:
            let parseFavorites = getUserFavoritesFromLocal(currentUser!);
            if !parseFavorites.isEmpty {
                for fav in parseFavorites {
                    favoriteCells.append(fav[ingredientColumn] as! PFIngredient)
                }
            }
        }
    }


}
