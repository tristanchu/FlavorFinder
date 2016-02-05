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
    var userLists = [PFObject]()

    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"

    // Visual related:
    let noUserMsg = "You must be logged in to have lists."
    let noListsMsg = "No Lists Yet!"
    let listsTitle = "Lists"
    let newListTitle = "Untitled"

    // Table itself:
    @IBOutlet var listsTableView: UITableView!

    // Nav bar:
    var newListBtn: UIBarButtonItem = UIBarButtonItem()
    let newListBtnAction = "newListBtnClicked"
    let newListBtnString = String.fontAwesomeIconWithName(.Plus) + " New List"

    // Segues:
    let segueToListDetail = "segueToListTable"


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
            if currentUser != nil {
                self.newListBtn.enabled = true
            } else {
                self.newListBtn.enabled = false
            }
        }

        // Populate and display table:
        populateListsTable()
        listsTableView.backgroundColor = UIColor.whiteColor();
        listsTableView.backgroundView = nil;
        
        // Do not display lists if no user:
        if currentUser == nil {
            listsTableView.backgroundView = emptyBackgroundListText(noUserMsg);

        // Yes user - no data; display message:
        } else if userLists.isEmpty {
            listsTableView.backgroundView = emptyBackgroundListText(noListsMsg);
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
                        emptyBackgroundListText(noListsMsg);
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

                    // TESTING:
                    // test empty list with "new List"
                    var testIngredients = []
                    // test non-empty list with List1:
                    if detailsPage.listTitle == "List1" {
                        let test1 = PFIngredient(name: "Cinnamon")
                        let test2 = PFIngredient(name: "Garlic")
                        testIngredients = [test1, test2]
                    }

                    // Make the table list the ingredients:
                    // TODO - need to be able to make this first.
                    detailsPage.ingredientList = testIngredients as! [PFIngredient]
                }
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
            userLists = getUserListsFromLocal(user)
        }
    }

    /* emptyBackgroundListText
        creates a backgroundView for when there is no data to display.
    text = text to display.
    */
    func emptyBackgroundListText(text: String) -> UILabel {
        let noDataLabel: UILabel = UILabel(frame: CGRectMake(
            0, 0, listsTableView.bounds.size.width,
            listsTableView.bounds.size.height))
        noDataLabel.text = text
        noDataLabel.textColor = UIColor(
            red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0);
        noDataLabel.textAlignment = NSTextAlignment.Center;
        return noDataLabel;
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
        let newList = createIngredientList(
            currentUser!, title: newListTitle, ingredients: []) as PFObject
        // Update table view:
        self.userLists.append(newList)
        tableView.reloadData()
    }
    
}
