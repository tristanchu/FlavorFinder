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
    let createListCellIdentitfier = "createListCellIdentifier"
    var userLists = [PFObject]()

    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"

    // Table itself:
    @IBOutlet var addToListTableView: UITableView!
    
    // Strings:
    let newListCellTitle = "Create new list with ingredients"
    let pageTitle = "Add To List"
    let newListTitle = "New Untitled List"

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
        addToListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: createListCellIdentitfier)

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
                self.tabBarController?.navigationItem.title = pageTitle;
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
            // create new at first cell:

            if (indexPath.row == 0){
                // set cell identifier:
                let cell = tableView.dequeueReusableCellWithIdentifier(createListCellIdentitfier, forIndexPath: indexPath)
                // set Cell label:
                cell.textLabel?.text = newListCellTitle
                // Give cell a chevron:
                cell.accessoryType =
                    UITableViewCellAccessoryType.DisclosureIndicator
                return cell

            // User lists at other cells:
            } else {
                // set cell identifier:
                let cell = tableView.dequeueReusableCellWithIdentifier(
                    listCellIdentifier, forIndexPath: indexPath)

                // Set cell label:
                cell.textLabel?.text = userLists[indexPath.row - 1].objectForKey(
                    ListTitleColumnName) as? String
                return cell
            }
    }

    /* tableView -> Add current search to selected list
        - adds either to existing list or creates new list with current search:
    */
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            // Create new list:
            if (indexPath.row == 0){
                var list = [PFIngredient]()
                for ingredient in currentSearch{ list.append(ingredient) }
                createIngredientList(currentUser!,
                    title: newListTitle, ingredients: list)

            // Picked an existing list:
            } else {
                let listObject = userLists[indexPath.row - 1]
                var list = listObject.objectForKey(ingredientsColumnName) as! [PFIngredient]
                // add each ingredient in current search:
                for ingredient in currentSearch{
                    if !list.contains(ingredient) {
                        list.append(ingredient)
                    }
                }
                // update with new ingredient list:
                listObject.setObject(list, forKey: ingredientsColumnName)
                listObject.saveInBackground()
            }
        // go back to search page:
        self.navigationController?.popViewControllerAnimated(true)
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

