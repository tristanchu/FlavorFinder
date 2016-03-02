//
//  ListDetailController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/28/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class ListDetailController: UITableViewController {
    
    // MARK: Properties:
    let listDetailCell = "listDetailCellIdentifier"
    let addToListCellIdentifier = "addToListCellIdentifier"
    let listToSearchCellIdentifier = "listToSearchCellIdentifier"
    var ingredientList = [PFIngredient]()
    var userList: PFObject!  // reference to list for editing
    
    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"
    
    // Visual related:
    var listTitle = ""
    var noIngredients = " has no ingredients!"
    let addToListText = String.fontAwesomeIconWithName(.Plus) + " Add New Ingredient"
    let listToSearchText = String.fontAwesomeIconWithName(.Search) + " Start Search With List"
    
    // Table itself:
    @IBOutlet var ingredientListsTableView: UITableView!
    
    // Navigation:
    var backBtn: UIBarButtonItem = UIBarButtonItem()
    let backBtnAction : Selector = "backBtnClicked"
    let backBtnString = String.fontAwesomeIconWithName(.ChevronLeft) + " All Lists"
    
    var editBtn: UIBarButtonItem = UIBarButtonItem()
    let editBtnAction : Selector = "editBtnClicked"
    let editBtnString = "Rename List"
    
    // Segues:
    let segueToEditPage = "segueToEditListPage"
    let segueToAddToListPage = "segueToAddToListPage"
    let segueToSearch = "segueToSearch"

    // MARK: Override methods: ----------------------------------------------
    /* viewDidLoad:
        Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect table view to this controller        
        ingredientListsTableView.dataSource = self
        ingredientListsTableView.delegate = self
//        ingredientListsTableView.registerClass(ListIngredientTableViewCell.self, forCellReuseIdentifier: listDetailCell)
        ingredientListsTableView.registerClass(ListIngredientTableViewCell.self, forCellReuseIdentifier: addToListCellIdentifier)
        ingredientListsTableView.registerClass(ListIngredientTableViewCell.self, forCellReuseIdentifier: listToSearchCellIdentifier)
        
        // Table view visuals:
        ingredientListsTableView.tableFooterView = UIView(frame: CGRectZero)  // remove empty cells
        ingredientListsTableView.rowHeight = UNIFORM_ROW_HEIGHT
        ingredientListsTableView.backgroundColor = BACKGROUND_COLOR

        // Navigation Visuals:
        setUpBackButton()
        setUpEditButton()
    }

    /* viewDidAppear:
        Setup when user goes into page.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Update title in case changed::
        listTitle = userList.objectForKey(ListTitleColumnName) as! String
        
        // Update ingredients list in case changed:
        ingredientList = userList.objectForKey(ingredientsColumnName) as! [PFIngredient]

        // Get navigation bar on top:
        if let navi = self.tabBarController?.navigationController
            as? MainNavigationController {
                self.tabBarController?.navigationItem.setLeftBarButtonItems(
                    [self.backBtn], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [self.editBtn], animated: true)
                navi.reset_navigationBar()
                self.tabBarController?.navigationItem.title = "\(self.listTitle)"
                self.backBtn.enabled = true
                self.editBtn.enabled = true
        }
        
        // NOTE: no population because data passed in during segue.

        // reset background:
        ingredientListsTableView.backgroundColor = BACKGROUND_COLOR;
        ingredientListsTableView.backgroundView = nil;
        
        // If no data, display message:
        if ingredientList.isEmpty {
            ingredientListsTableView.backgroundView = emptyBackgroundText(
                self.listTitle + self.noIngredients, view: ingredientListsTableView as UIView)
        }

        // Update table view:
        ingredientListsTableView.reloadData()
    }
    
    /*  tableView -> int
    returns number of cells to display
    */
    override func tableView(
        tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (ingredientList.count == 0){
                return self.ingredientList.count + 1 // add 1 for add to list
            } else {
                return self.ingredientList.count + 2 // add to list + make search
            }
    }
    
    /* tableView -> UITableViewCell
    creates cell for each index in favoriteCells
    */
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            // Add To List Cell:
            if (indexPath.row == 0){
                // set cell identifier:
                let cell = tableView.dequeueReusableCellWithIdentifier(
                    addToListCellIdentifier, forIndexPath: indexPath)
                // set Cell label:
                cell.textLabel?.text = addToListText
                cell.textLabel?.font = CELL_FONT_AWESOME
                cell.textLabel?.textColor = UIColor.grayColor()
                // Give cell a chevron:
                cell.accessoryType =
                    UITableViewCellAccessoryType.DisclosureIndicator
                // No delete option:
                cell.setEditing(false, animated: false)
                return cell
                
            // if last cell - have add to list cell:
            } else if (!ingredientList.isEmpty &&  indexPath.row == ingredientList.count + 1) {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(
                    listToSearchCellIdentifier, forIndexPath: indexPath)
                // set Cell label:
                cell.textLabel?.text = listToSearchText
                cell.textLabel?.font = CELL_FONT_AWESOME
                cell.textLabel?.textColor = UIColor.grayColor()
                // Give cell a chevron:
                cell.accessoryType =
                    UITableViewCellAccessoryType.DisclosureIndicator
                // No delete option:
                cell.setEditing(false, animated: false)
                
                return cell

            // regular ingredient cell:
            } else {
                // set cell identifier:
                let cell = tableView.dequeueReusableCellWithIdentifier(
                    listDetailCell, forIndexPath: indexPath) as! ListIngredientTableViewCell
                
                // Set cell label:
                let listIngredient = ingredientList[indexPath.row - 1]
                cell.textLabel?.text = listIngredient.name
                cell.textLabel?.font = CELL_FONT
                
//                cell.icons.removeAll()
//                
//                let isNuts = listIngredient[_s_nuts] as! Bool
//                let isDairy = listIngredient[_s_dairy] as! Bool
//                let isVege = listIngredient[_s_vegetarian] as! Bool
//                
//                var isFavorite = false
//                if let user = currentUser {
//                    if let _ = isFavoriteIngredient(user, ingredient: listIngredient) {
//                        isFavorite = true
//                    }
//                }
//                
//                if isVege {
//                    let imageVegan = UIImage(named: "Vegetarian")!
//                    cell.icons.append(imageVegan)
//                }
//                if isNuts {
//                    let imageNuts = UIImage(named: "Nuts")!
//                    cell.icons.append(imageNuts)
//                }
//                if isDairy {
//                    let imageDairy = UIImage(named: "Dairy")!
//                    cell.icons.append(imageDairy)
//                }
//                if isFavorite {
//                    let imageFav = UIImage(named: "Heart")!
//                    cell.icons.append(imageFav)
//                }
//                
//                cell.ingredientIcons.reloadData()
                
                return cell
            }
    }
    
    /* tableView -> Does something on selection of row
    */
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0){
            self.performSegueWithIdentifier(segueToAddToListPage, sender: self)
        } else if (indexPath.row == ingredientList.count + 1) { // start search
            currentSearch = ingredientList
            self.tabBarController?.setValue(0, forKey: "selectedIndex") // switch tabs
        }
    }

    /* tableView - choose which rows are editable (delete shows)
                - makes it so the first row is not.g
    */
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return (indexPath.row != 0 && indexPath.row != ingredientList.count + 1)
    }

    /* tableView; Delete a cell:
    */
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            if (indexPath.row != 0){
                if editingStyle == UITableViewCellEditingStyle.Delete {
                    // Tell parse to remove ingredient in list from local db:
                    removeIngredientFromList(userList, ingredient: self.ingredientList[indexPath.row - 1])
                    
                    if (indexPath.row - 1 == 0) {
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        // remove from display table:
                        self.ingredientList.removeAtIndex(indexPath.row - 1)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                        
                        // Show empty message if needed:
                        if self.ingredientList.isEmpty {
                            ingredientListsTableView.backgroundView = emptyBackgroundText(
                                self.listTitle + self.noIngredients, view: ingredientListsTableView as UIView)
                        }
                    }
                }
            }
    }


    /* prepareForSegue
        - sends info to Edit page and Add to list page
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueToEditPage ) {
            if let editPage = segue.destinationViewController as? EditListPage {
                editPage.listObject = self.userList
                editPage.listTitle = self.userList.objectForKey(ListTitleColumnName) as! String
            }
        } else if (segue.identifier == segueToAddToListPage) {
            if let addToListPage = segue.destinationViewController as? AddToListPage {
                addToListPage.listObject = self.userList
                addToListPage.listTitle = self.userList.objectForKey(ListTitleColumnName) as! String
            }
        }
    }


    // MARK: Functions -------------------------------------------------

    /* createBackgroundWithText
    creates a backgroundView for when there is no data to display.
    text = text to display.
    */
    func createBackgroundWithText(text: String) -> UILabel {
        let noDataLabel: UILabel = UILabel(frame: CGRectMake(
            0, 0, ingredientListsTableView.bounds.size.width,
            ingredientListsTableView.bounds.size.height))
        noDataLabel.text = text
        noDataLabel.textColor = UIColor(
            red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0);
        noDataLabel.textAlignment = NSTextAlignment.Center;
        return noDataLabel;
    }

    // MARK: Back Button Functions -------------------------------------

    /* setUpBackButton
        sets up the back button visuals for navigation
    */
    func setUpBackButton() {
        setUpNaviButton(backBtn, buttonString: backBtnString, target: self, action: backBtnAction)
    }
    
    /* backBtnClicked
        - action for back button
    */
    func backBtnClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Edit Button Functions -------------------------------------
    
    /* setUpEditButton
        sets up the edit button visuals  for navigation
    */
    func setUpEditButton() {
        setUpNaviButton(editBtn, buttonString: editBtnString, target: self, action: editBtnAction)
    }
    
    /* editBtnClicked
        - action for edit button
    */
    func editBtnClicked() {
        self.performSegueWithIdentifier(segueToEditPage, sender: self)

    }

}
