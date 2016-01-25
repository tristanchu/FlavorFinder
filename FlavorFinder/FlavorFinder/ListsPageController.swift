//
//  ListsPageController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse
import DZNEmptyDataSet

class ListsPageController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    let listCellIdentifier = "listCellIdentifier"
    var ingredientLists = [PFObject]()
    
    @IBOutlet var listsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listsTableView = UITableView()
        listsTableView.dataSource = self
        listsTableView.delegate = self
        listsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: listCellIdentifier)
        listsTableView.emptyDataSetSource = self
        listsTableView.emptyDataSetDelegate = self
        
        populateListsTable()
        listsTableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredientLists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(listCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = ingredientLists[indexPath.row][_s_title] as? String
        return cell
    }
    
    
    // MARK: Functions -------------------------------------------------
    
    func populateListsTable() {
        ingredientLists.removeAll()
        
        if let user = currentUser {
            ingredientLists = getUserListsFromLocal(user)
        }
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = String.fontAwesomeIconWithName(.FrownO)
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(100)] as Dictionary!
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if let _ = currentUser {
            let text = "You need to create an ingredient list to see anything here!"
            return NSAttributedString(string: text, attributes: attributes)
        } else {
            let text = "You must register and login in order to create ingredient lists."
            return NSAttributedString(string: text, attributes: attributes)
        }
    }
    
}
