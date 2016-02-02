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
    var ingredientList = [PFIngredient]()
    
    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"
    
    // Visual related:
    var listTitle = ""
    var noIngredients = " has no ingredients!"
    
    // Table itself:
    @IBOutlet var ingredientListsTableView: UITableView!
    
    // Navigation:
    var backBtn: UIBarButtonItem = UIBarButtonItem()
    let backBtnAction = "backBtnClicked:"
    let backBtnString = String.fontAwesomeIconWithName(.ChevronLeft) + " All Lists"

    // MARK: Override methods: ----------------------------------------------
    /* viewDidLoad:
        Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect table view to this controller        
        ingredientListsTableView.dataSource = self
        ingredientListsTableView.delegate = self
        ingredientListsTableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: listDetailCell)
        
        // Table view visuals:
        ingredientListsTableView.tableFooterView = UIView(frame: CGRectZero)  // remove empty cells
        ingredientListsTableView.rowHeight = UNIFORM_ROW_HEIGHT

        // Navigation Visuals:
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
                self.tabBarController?.navigationItem.setLeftBarButtonItems(
                    [self.backBtn], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                navi.reset_navigationBar()
                self.backBtn.enabled = true
        }
        
        // NOTE: no population because data passed in during segue.

        // reset background:
        ingredientListsTableView.backgroundColor = UIColor.whiteColor();
        ingredientListsTableView.backgroundView = nil;
        
        // If no data, display message:
        if ingredientList.isEmpty {
            ingredientListsTableView.backgroundView = createBackgroundWithText(
                self.listTitle + self.noIngredients)
        }

        // Update table view:
        ingredientListsTableView.reloadData()
    }
    
    /*  tableView -> int
    returns number of cells to display
    */
    override func tableView(
        tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.ingredientList.count
    }
    
    /* tableView -> UITableViewCell
    creates cell for each index in favoriteCells
    */
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            // set cell identifier:
            let cell = tableView.dequeueReusableCellWithIdentifier(
                listDetailCell, forIndexPath: indexPath)
            
            // Set cell label:
            cell.textLabel?.text = ingredientList[indexPath.row].name
            return cell
    }
    
    
    
    
    // MARK: Functions -------------------------------------------------

    /* setUpBackButton
        sets up the back button for navigation
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

}
