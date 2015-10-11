//
//  MatchTableViewController.swift
//  FlavorFinder
//
//  Created by Sudikoff Lab iMac on 10/8/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit
import SQLite

class MatchTableViewController: UITableViewController, UITableViewDelegate {
    // MARK: Properties
    
    var matchesTable: Query!
    var ingredientsTable: Query!
    let SCHEMA_TABLE_INGREDIENTS = "ingredients"
    let SCHEMA_TABLE_MATCHES = "matches"
    let SCHEMA_COL_ID = Expression<Int>("id")
    let SCHEMA_COL_MATCHID = Expression<Int>("match_id")
    let SCHEMA_COL_NAME = Expression<String>("name")

    var allIngredients = [Ingredient]()
    var displayedCells = [Ingredient]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMatches()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadMatches() {
        let dbpath = NSBundle.mainBundle().pathForResource("flavorbible", ofType: "db")
        let db = Database(dbpath!)
        
        ingredientsTable = db[SCHEMA_TABLE_INGREDIENTS]
        matchesTable = db[SCHEMA_TABLE_MATCHES];
        
        for ingredient in ingredientsTable {
            let possible_id : Int? = ingredient[SCHEMA_COL_ID]
            let possible_name : String? = ingredient[SCHEMA_COL_NAME]
            if let id = possible_id, let name = possible_name {
                if name.isEmpty == false {
                    var i = Ingredient(id: id, name: name)!
                    allIngredients.append(Ingredient(id: id, name: name)!)
                }
            }
        }
        
        displayedCells = allIngredients
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return displayedCells.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MatchTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatchTableViewCell

        // Fetches the appropriate ingredient to display.
        let ingredient = displayedCells[indexPath.row]
        cell.nameLabel.text = ingredient.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let ingredient = displayedCells[indexPath.row]
        
        let matches = matchesTable.filter(SCHEMA_COL_ID == ingredient.id)
        
        displayedCells.removeAll()
        
        for m in matches {
            if let found = find(lazy(allIngredients).map({ $0.id == m[self.SCHEMA_COL_MATCHID] }), true) {
                displayedCells.append(allIngredients[found])
            }
        }
        
        self.tableView.reloadData()
        //        self.performSegueWithIdentifier("yourIdentifier", sender: self)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
