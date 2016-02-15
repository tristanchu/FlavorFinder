//
//  MenuTableViewController.swift
//  FlavorFinder
//
//  Created by Jon on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit


class MenuTableViewController: UITableViewController {

    // Default to logged out state.
    var menuTableItems = [ "Save Search to List",
        "Add Ingredient",
        "Add Match for Current Search"
    ]
    
    let colors = [ UIColor(red: 59/255.0, green: 247/255.0, blue: 194/255.0, alpha: CGFloat(1.0)),
                    UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(1.0)),
                    UIColor(red: 227/255.0, green: 78/255.0, blue: 59/255.0, alpha: CGFloat(1.0))]
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(CELLIDENTIFIER_MENU, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.font = UIFont.fontAwesomeOfSize(15)
        cell.textLabel?.text = self.menuTableItems[indexPath.row]
        cell.textLabel?.textAlignment = .Center
        cell.backgroundColor = self.colors[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuTableItems.count
    }
}
