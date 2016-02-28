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
        "Add New Match"     : "segueMoreToAddMatch"
    ]
    var morePages = [String : String]() // PageName : SegueName
 
    // MARK: Override methods: ----------------------------------------------
    
    /* viewDidLoad:
    - Additional setup after loading the view
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: moreCellIdentifier)

    }
    
    /* viewDidAppear:
    - Setup when view appears
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Configure navigation bar on top
        if let navi = self.tabBarController?.navigationController
            as? MainNavigationController {
                self.tabBarController?.navigationItem.setLeftBarButtonItems(
                    [], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                navi.reset_navigationBar()
                self.tabBarController?.navigationItem.title = "More"
        }

        // Determine what features user has access to
        if currentUser != nil {
            morePages = morePagesLoggedIn
        } else {
            morePages = morePagesLoggedOut
        }
        
        // Reload table
        tableView.reloadData()
    }
    
    // MARK: Table VC methods: ----------------------------------------------
    
    /*  tableView -> int
    - returns number of cells to display, which is the number of pages available
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return morePages.count
    }
    
    /* tableView -> UITableViewCell
    - creates cell for each accessible "more" page
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(moreCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = Array(morePages.keys)[indexPath.row] as String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator // chevron
        cell.setEditing(false, animated: false) // no deleting
        return cell
    }
    
    /* tableView -> Does something on selection of row
    - segues to selected page
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(Array(morePages.values)[indexPath.row], sender: self)
    }

}