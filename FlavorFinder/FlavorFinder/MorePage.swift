//
//  MorePage.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/27/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit

class MorePage : UITableViewController {
    
    // MARK: Properties: ----------------------------------------------------
    let moreCellIdentifier = "morePageCellIdentifier"
    let morePagesLoggedOut = ["About" : "segueMoreToAbout"]
    let morePagesLoggedIn = [
        "About"             : "segueMoreToAbout",
        "Add New Match"     : "segueMoreToNewMatch"
    ]
    var morePages = [String : String]()
 
    // MARK: Override methods: ----------------------------------------------
    
    /* viewDidLoad:
    - Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentUser != nil {
            morePages = morePagesLoggedIn
        } else {
            morePages = morePagesLoggedOut
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: moreCellIdentifier)

    }
    
    
    // MARK: Table VC methods: ----------------------------------------------
    
    /*  tableView -> int
    - returns number of cells to display, which is the number of pages available
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return morePages.count
    }
    
    /* tableView -> UITableViewCell
    creates cell for each index in favoriteCells
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(moreCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = Array(morePages.keys)[indexPath.row] as String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator // chevron
        cell.setEditing(false, animated: false) // no deleting
        return cell
    }
    
    /* tableView -> Does something on selection of row
    */
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
//            if (indexPath.row == 0){
//                self.performSegueWithIdentifier(segueToAddToListPage, sender: self)
//            } else if (indexPath.row == ingredientList.count + 1) { // start search
//                currentSearch = ingredientList
//                self.tabBarController?.setValue(0, forKey: "selectedIndex") // switch tabs
//            }
    }

    
}
