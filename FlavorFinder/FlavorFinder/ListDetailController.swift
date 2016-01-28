//
//  ListDetailController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/27/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class ListDetailController: UITableViewController {

    // MARK: Properties:
    
    var userList: PFObject!
    var ingredientList = [PFIngredient]()
    
    let listDetailCellIdentifier = "listDetailIdentifier"
    
    @IBOutlet var listDetailTableView: UITableView!
    
    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"
    
    // MARK: Override methods: ----------------------------------------------
    /* viewDidLoad:
    Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect table view to this controller        listsTableView.dataSource = self
        listDetailTableView.delegate = self
        listDetailTableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: listDetailCellIdentifier)
        
        // Table view visuals:
        listDetailTableView.tableFooterView = UIView(frame: CGRectZero)  // remove empty cells
        listDetailTableView.rowHeight = 60.0
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
                self.tabBarController?.navigationItem.title = "List Detail Page"
        }
        
        listDetailTableView.backgroundColor = UIColor.whiteColor();
        listDetailTableView.backgroundView = nil;
        
        listDetailTableView.reloadData()
        
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
                listDetailCellIdentifier, forIndexPath: indexPath)
            
            // Set cell label:
            cell.textLabel?.text = "Test object"
            return cell
    }
    
    
    
    
}
