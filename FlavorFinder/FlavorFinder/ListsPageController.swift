//
//  ListsPageController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class ListsPageController: UITableViewController {

    // MARK: Properties:
    let listCellIdentifier = "listCellIdentifier"
    var ingredientLists = [PFObject]()

    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"

    // Visual related:
    let noUserMsg = "You must be logged in to have lists."
    let noListsMsg = "No Lists Yet!"

    // Table itself:
    @IBOutlet var listsTableView: UITableView!



    // MARK: Override methods: ----------------------------------------------
    /* viewDidLoad:
        Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Connect table view to this controller        listsTableView.dataSource = self
        listsTableView.delegate = self
        listsTableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: listCellIdentifier)

        // Table view visuals:
        listsTableView.tableFooterView = UIView(frame: CGRectZero)  // remove empty cells
        listsTableView.rowHeight = 80.0
    }

    /* viewDidAppear:
            Setup when user goes into page.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Get navigation bar on top:
        if let navi = self.tabBarController?.navigationController
                as? MainNavigationController {
            self.tabBarController?.navigationItem.setLeftBarButtonItems(
                [], animated: true)
            self.tabBarController?.navigationItem.setRightBarButtonItems(
                [], animated: true)
            navi.reset_navigationBar()
            self.tabBarController?.navigationItem.title = ""
        }

        // Populate and display table:
        populateListsTable()
        listsTableView.backgroundColor = UIColor.whiteColor();
        listsTableView.backgroundView = nil;
        
        // Display empty message if not data:
        if ingredientLists.isEmpty {
            if currentUser == nil {
                listsTableView.backgroundView = emptyBackgroundListText(noUserMsg);
            } else {
                listsTableView.backgroundView = emptyBackgroundListText(noListsMsg);
            }
        }

        // Update table view:
        print(ingredientLists.count);
        listsTableView.reloadData()
    }

    /*  tableView -> int
            returns number of cells to display
    */
    override func tableView(
        tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredientLists.count
    }

    /* tableView -> UITableViewCell
            creates cell for each index in favoriteCells
    */
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // set cell identifier:
        let cell = tableView.dequeueReusableCellWithIdentifier(
            listCellIdentifier, forIndexPath: indexPath)
        // Set cell label:
        cell.textLabel?.text = ingredientLists[indexPath.row][_s_title] as? String
        return cell
    }


    // MARK: Functions -------------------------------------------------

    /* populateListsTable:
    clears current ingredientLists array; gets user lists from parse local db
    if user is logged in.
    */
    func populateListsTable() {
        ingredientLists.removeAll()
        
        // Get user's lists from Parse local db if user logged in:
        if let user = currentUser {
            ingredientLists = getUserListsFromLocal(user)
        }
    }

    /* emptyBackgroundText
        creates a backgroundView for when there is no data to display.
    text = text to display.
    */
    func emptyBackgroundListText(text: String) -> UILabel {
        print(" In here!!")
        let noDataLabel: UILabel = UILabel(frame: CGRectMake(
            0, 0, listsTableView.bounds.size.width,
            listsTableView.bounds.size.height))
        noDataLabel.text = text
        noDataLabel.textColor = UIColor(
            red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0);
        noDataLabel.textAlignment = NSTextAlignment.Center;
        return noDataLabel;
    }
    
}
