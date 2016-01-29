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
    let noIngredients = "You have nothing in this list!"
    
    // Table itself:
    @IBOutlet var ingredientListsTableView: UITableView!
    
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
        ingredientListsTableView.rowHeight = 80.0
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
        populateListDetailTable()
        ingredientListsTableView.backgroundColor = UIColor.whiteColor();
        ingredientListsTableView.backgroundView = nil;
        
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
    
    /* populateListsTable:
    clears current userLists array; gets user lists from parse local db
    if user is logged in.
    */
    func populateListDetailTable() {
        ingredientList.removeAll()
        
        // Get user's lists from Parse local db if user logged in:
        let test = PFIngredient(className: "testing thing")
        ingredientList.append(test)
    }
}
