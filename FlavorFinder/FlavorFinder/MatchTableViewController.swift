//
//  MatchTableViewController.swift
//  FlavorFinder
//
//  Created by Sudikoff Lab iMac on 10/8/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit
import SQLite

struct Stack<Element> {
    var items = [Element]()
    mutating func push(item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element? {
        if items.isEmpty {
            return nil
        } else {
            return items.removeLast()
        }
    }
    mutating func removeAll() {
        items.removeAll()
    }
    mutating func isEmpty() -> Bool {
        return items.isEmpty
    }
}

class MatchTableViewController: UITableViewController, UITableViewDelegate, UISearchBarDelegate {
    // MARK: Properties
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: Actions
    @IBOutlet weak var goBackBtn: UIBarButtonItem!
    @IBOutlet weak var goForwardBtn: UIBarButtonItem!
    
    // GLOBALS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // -------
    var matchesTable: Query!
    var ingredientsTable: Query!
    
    // Constants for schema strings.
    let SCHEMA_TABLE_INGREDIENTS = "ingredients"
    let SCHEMA_TABLE_MATCHES = "matches"
    let SCHEMA_COL_ID = Expression<Int>("id")
    let SCHEMA_COL_MATCHID = Expression<Int>("match_id")
    let SCHEMA_COL_MATCHLEVEL = Expression<Int>("match_level")
    let SCHEMA_COL_NAME = Expression<String>("name")

    // Array of all ingredients from database.
    var allIngredients = [Ingredient]()
    
    // Array of all cells that CAN be displayed.
    var allCells = [Ingredient]()
    
    // Array of all cells that ARE displayed (filtered version of 'allCells').
    var filteredCells = [Ingredient]()
    
    // This boolean will activate the colored backgrounds.
    // We only want to show the colors when viewing matches, not the list of all ingredients.
    var viewingMatches = false
    
    var currentIngredient : Ingredient?
    
    // Used for going backward.
    var history = Stack<Ingredient?>()
    
    // Used for going forward.
    var future = Stack<Ingredient?>()
    // ---------------------------------------------------------
    
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        if let curr = currentIngredient {
            if let pastIngredient = history.pop() {
                showIngredient(pastIngredient!)
            } else {
                goBackBtn.enabled = false
                showAllIngredients()
            }
            future.push(curr)
            goForwardBtn.enabled = true
        }
    }
    
    @IBAction func goForward(sender: UIBarButtonItem) {
        if let futureIngredient = future.pop() {
            if let curr = currentIngredient {
                history.push(curr)
                goBackBtn.enabled = true
            }
            showIngredient(futureIngredient!)
        }
    }
    
    func pushToHistory() {
        future.removeAll()
        if let curr = currentIngredient {
            history.push(curr)
        }
        goBackBtn.enabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goBackBtn.enabled = false
        goForwardBtn.enabled = false
        
        loadIngredients()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func showAllIngredients() {
        allCells = allIngredients
        filteredCells = allIngredients
        self.title = "All Ingredients"
        currentIngredient = nil
        
        self.tableView.reloadData()
    }
    
    func showIngredient(ingredient: Ingredient) {
        currentIngredient = ingredient
        
        // Set navigation title to ingredient's name.
        self.title = ingredient.name
        
        // Get all the match ids of matches for this ingredient.
        let matches = matchesTable.filter(SCHEMA_COL_ID == ingredient.id)
        
        // Reset 'allCells' with the ingredients that have those match ids.
        allCells.removeAll()
        for m in matches {
            if let found = find(lazy(allIngredients).map({ $0.id == m[self.SCHEMA_COL_MATCHID] }), true) {
                allIngredients[found].matchLevel = m[SCHEMA_COL_MATCHLEVEL]
                allCells.append(allIngredients[found])
            }
        }
        
        // Reset 'filteredCells' with new matches.
        filteredCells = allCells
        
        // This boolean will activate the colored backgrounds.
        // We only want to show the colors when viewing matches, not the list of all ingredients.
        viewingMatches = true
        
        // Show the new ingredients on our table.
        self.tableView.reloadData()
        
        //        self.performSegueWithIdentifier("yourIdentifier", sender: self)
    }
    
    func loadIngredients() {
        let dbpath = NSBundle.mainBundle().pathForResource("flavorbible", ofType: "db")
        let db = Database(dbpath!)
        
        // Fetch our ingredient
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
        
        showAllIngredients()
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
        return filteredCells.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MatchTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatchTableViewCell

        // Fetches the appropriate ingredient to display.
        let ingredient = filteredCells[indexPath.row]
        
        // Set's the cell label to the ingredient's name.
        cell.nameLabel.text = ingredient.name
        
        if viewingMatches {
            switch ingredient.matchLevel {
                
            // Match: low. White.
            case 1:
                cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
            // Match: medium. Yellow.
            case 2:
                cell.backgroundColor = UIColor(red: 255/255.0, green: 237/255.0, blue: 105/255.0, alpha: CGFloat(0.3))
            // Match: high. Blue.
            case 3:
                cell.backgroundColor = UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
            // Match: greatest. Green.
            case 4:
                cell.backgroundColor = UIColor(red: 105/255.0, green: 255/255.0, blue: 150/255.0, alpha: CGFloat(0.3))
            // Default. White.
            default:
                cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        pushToHistory()
        
        // Get tapped ingredient.
        let ingredient = filteredCells[indexPath.row]
        
        showIngredient(ingredient)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCells.removeAll()
        
        if searchBar.text.isEmpty {
            filteredCells = allCells
        } else {
            for ingredient in allCells {
                if ingredient.name.rangeOfString(searchText.lowercaseString) != nil {
                    filteredCells.append(ingredient)
                }
            }
        }
        
        self.tableView.reloadData()
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
