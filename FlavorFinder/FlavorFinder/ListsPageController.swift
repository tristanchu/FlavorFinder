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
    var userLists = [PFList]()

    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"

    // Visual related:
    let noUserMsg = "You must be logged in to have lists."
    let noListsMsg = "No Lists Yet!"
    let listsTitle = "Lists"

    // Table itself:
    @IBOutlet var listsTableView: UITableView!

    // Nav bar:
    var newListBtn: UIBarButtonItem = UIBarButtonItem()
    let newListBtnAction = "newListBtnClicked"
    let newListBtnString = String.fontAwesomeIconWithName(.Plus) + " New List"

    // Segues:
    let segueToListDetail = "segueToListTable"
    let segueToCreateListPage = "segueToCreateListPage"


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
        listsTableView.rowHeight = UNIFORM_ROW_HEIGHT

        // Navigation Visuals:
        setUpNewListButton()
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
                [self.newListBtn], animated: true)
            navi.reset_navigationBar();
            self.tabBarController?.navigationItem.title = listsTitle;
            
            // enable new list button if user logged in:
            if isUserLoggedIn() {
                self.newListBtn.enabled = true
            } else {
                self.newListBtn.enabled = false
            }
        }

        // Populate and display table:
        populateListsTable()
        listsTableView.backgroundColor = BACKGROUND_COLOR;
        listsTableView.backgroundView = nil;
        
        // Do not display lists if no user:
        if !isUserLoggedIn() {
            listsTableView.backgroundView = emptyBackgroundText(noUserMsg, view: listsTableView as UIView);

        // Yes user - no data; display message:
        } else if userLists.isEmpty {
            listsTableView.backgroundView = emptyBackgroundText(noListsMsg, view: listsTableView as UIView);
        }

        // Update table view:
        listsTableView.reloadData()
    }

    /*  tableView -> int
            returns number of cells to display
    */
    override func tableView(
        tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userLists.count
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
        cell.textLabel?.text = userLists[indexPath.row].objectForKey(
            ListTitleColumnName) as? String
        cell.textLabel?.font = CELL_FONT


        // Give cell a chevron:
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    /* tableView -> Perform segue on select
        - segues to detail of row when selected
    */
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(segueToListDetail, sender: self)
    }

    /* tableView; Delete a cell:
    */
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == UITableViewCellEditingStyle.Delete {

                // Tell parse to remove list from local db:
                deleteIngredientList(self.userLists[indexPath.row])

                // remove from display table:
                self.userLists.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath],
                    withRowAnimation: UITableViewRowAnimation.Automatic)

                // Show empty message if needed:
                if self.userLists.isEmpty {
                    listsTableView.backgroundView =
                        emptyBackgroundText(noListsMsg, view: listsTableView);
                }
            }
    }
    
    /* prepareForSegue
        - sends info to details page
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == segueToListDetail ) {
            if let detailsPage = segue.destinationViewController as? ListDetailController {
                if let idx = listsTableView.indexPathForSelectedRow?.row {
                    // Make the title the name of list:
                    detailsPage.listTitle = (userLists[idx].objectForKey(
                        ListTitleColumnName) as? String)!
                    // give the actual list reference:
                    detailsPage.userList = (userLists[idx])
                }
            }
        } else if (segue.identifier == segueToCreateListPage) {
            if let newListPage = segue.destinationViewController as? CreateNewList {
                newListPage.userLists = self.userLists
            }
        }
    }

    // MARK: Functions -------------------------------------------------

    /* populateListsTable:
    clears current userLists array; gets user lists from parse local db
    if user is logged in.
    */
    func populateListsTable() {
        userLists.removeAll()
        
        // Get user's lists from Parse local db if user logged in:
        if let user = currentUser {
            userLists = getUserListsFromLocal(user) as! [PFList]
        }
    }

    // MARK: Add New List Button Functions ----------------------------

    /* setUpNewListButton
        sets up the new list button for navigation
    */
    func setUpNewListButton() {
        newListBtn.setTitleTextAttributes(attributes, forState: .Normal)
        newListBtn.title = self.newListBtnString
        newListBtn.tintColor = NAVI_BUTTON_COLOR
        newListBtn.target = self
        newListBtn.action = "newListBtnClicked"  // refers to newListBtnClicked()
    }

    /* newListBtnClicked
        - action for the new list button
    */
    func newListBtnClicked() {
        self.performSegueWithIdentifier(segueToCreateListPage, sender: self)
    }
    
}