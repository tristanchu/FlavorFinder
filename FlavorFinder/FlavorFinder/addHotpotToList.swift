//
//  addHotpotToList.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/15/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class AddHotpotToListController: UITableViewController {

    // MARK: Properties:
    let listCellIdentifier = "listAddCellIdentifier"
    var userLists = [PFObject]()

    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"

    // Table itself:
    @IBOutlet var addToListTableView: UITableView!

    // Navigation:
    var backBtn: UIBarButtonItem = UIBarButtonItem()
    let backBtnAction = "backBtnClicked:"
    let backBtnString = String.fontAwesomeIconWithName(.ChevronLeft) + " Cancel"

    // MARK: Override methods: ----------------------------------------------
    /* viewDidLoad:
    Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Connect table view to  this controller:
        addToListTableView.delegate = self
        addToListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: listCellIdentifier)

        // Table view visuals:
        // remove empty cells
        addToListTableView.tableFooterView = UIView(frame: CGRectZero)
        addToListTableView.rowHeight = UNIFORM_ROW_HEIGHT

        // Set up back button
        setUpBackButton()
    }

    /* viewDidAppear:
    Setup when user goes into page.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Get navigation bar on top:
        if let navi = self.tabBarController?.navigationController
            as? MainNavigationController {
                navi.reset_navigationBar();
                self.tabBarController?.navigationItem.setLeftBarButtonItems(
                    [self.backBtn], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                self.tabBarController?.navigationItem.title = "Choose a list";
                self.backBtn.enabled = true
        }

        // Populate and display table:
        populateListsTable()

        // Update table view:
        addToListTableView.reloadData()
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
            print("Clicked on cell")
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

    // MARK: Back Button Functions -------------------------------------

    /* setUpBackButton
    sets up the back button visuals for navigation
    */
    func setUpBackButton() {
        backBtn.setTitleTextAttributes(attributes, forState: .Normal)
        backBtn.title = self.backBtnString
        backBtn.tintColor = NAVI_BUTTON_COLOR
        backBtn.target = self
        backBtn.action = "backBtnClicked"  // refers to: backBtnClicked()
    }

    /* backBtnClicked
    - action for back button
    */
    func backBtnClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

