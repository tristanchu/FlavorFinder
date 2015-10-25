//
//  MatchTableViewController.swift
//  FlavorFinder
//
//  Created by Sudikoff Lab iMac on 10/8/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit
import SQLite
import Parse
import FontAwesome_swift
import Darwin

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

class MatchTableViewController: UITableViewController, UISearchBarDelegate {
    // MARK: Properties
    lazy var searchBar = UISearchBar(frame: CGRectMake(0, 0, 0, 0))
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var searchBarActivateBtn: UIBarButtonItem!
    var activateBtn: UIButton = UIButton()
    var searchBarActivateBtn: UIBarButtonItem = UIBarButtonItem()

    var menuBtn: UIButton = UIButton()
    var menuBarBtn: UIBarButtonItem = UIBarButtonItem()
//    var searchBarActivateBtn : [String : AnyObject] = UIBarButtonItem(title: "test", style: .Plain, target: self, action: "barButtonItemClicked:")
    
    
    // MARK: Actions
    @IBOutlet weak var goBackBtn: UIBarButtonItem!
    @IBOutlet weak var goForwardBtn: UIBarButtonItem!
    
    // GLOBALS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // -------
    var db: Connection!
    var matchesTable: Table!
    var ingredientsTable: Table!
    
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
    
    var menuTableView: UITableView = UITableView()
    var menuItems = [UIButton]()
    // ---------------------------------------------------------
    
    
    // NAVI FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // --------------
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
            }
            
            goBackBtn.enabled = true
            showIngredient(futureIngredient!)
        }
    }
    
    func pushToHistory() {
        future.removeAll()
        if let curr = currentIngredient {
            history.push(curr)
        }
        goBackBtn.enabled = true
        goForwardBtn.enabled = false
    }
    // ---------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        // Disable buttons by default.
        goBackBtn.enabled = false
        goForwardBtn.enabled = false

        searchBar.hidden = true
        searchBar.setShowsCancelButton(true, animated: false)
        
        activateBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        activateBtn.setTitle(String.fontAwesomeIconWithName(.Github), forState: .Normal)
        
//        searchBarActivateBtn.customView = activateBtn
        var attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        searchBarActivateBtn.setTitleTextAttributes(attributes, forState: .Normal)
        searchBarActivateBtn.title = String.fontAwesomeIconWithName(.Github)
        
        attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        menuBarBtn.setTitleTextAttributes(attributes, forState: .Normal)
        menuBarBtn.title = String.fontAwesomeIconWithName(.Bars)
        menuBarBtn.target = self
        menuBarBtn.action = "menuBtnClicked"
        
        self.navigationItem.setLeftBarButtonItems([self.goBackBtn, self.searchBarActivateBtn], animated: true)
        self.navigationItem.setRightBarButtonItems([self.goForwardBtn, self.menuBarBtn], animated: true)

        menuTableView.frame = CGRectMake(0, 0, self.view.frame.width, 200);
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        menuTableView.tableFooterView = UIView.init(frame: CGRectZero)
        menuTableView.tableFooterView!.hidden = true
        menuTableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(menuTableView)
        menuTableView.hidden = true
        

        let menuProfileBtn = UIButton()
        menuProfileBtn.titleLabel?.text = String.fontAwesomeIconWithName(.User) + " Profile"
        
        let menuIngredientsBtn = UIButton()
        menuIngredientsBtn.setTitle(String.fontAwesomeIconWithName(.Cutlery) + " Ingredients", forState: .Normal)
        
        let menuSignInOutBtn = UIButton()
        menuSignInOutBtn.setTitle(String.fontAwesomeIconWithName(.SignOut) + " Sign Out", forState: .Normal)
        
        menuItems = [menuProfileBtn, menuIngredientsBtn, menuSignInOutBtn]
        
        // Show all ingredients to start.
        loadIngredients()
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func menuBtnClicked() {
        print("menuBtn clicked.")
        if (menuTableView.hidden) {
            menuTableView.hidden = false
            animateMenuTableView(false)
        } else {
//            animateMenuTableView(true)
            menuTableView.hidden = true
        }
    }
    
    func showAllIngredients() {
        viewingMatches = false
        allCells = allIngredients
        filteredCells = allIngredients
        self.title = "All Ingredients"
        currentIngredient = nil
        
        animateTable()
    }
    
    func showIngredient(ingredient: Ingredient) {
        currentIngredient = ingredient
        
        // Set navigation title to ingredient's name.
        self.title = ingredient.name
        
        // Get all the match ids of matches for this ingredient.
        let matches = matchesTable.filter(SCHEMA_COL_ID == ingredient.id)
        
        // Reset 'allCells' with the ingredients that have those match ids.
        allCells.removeAll()
        for m in db.prepare(matches) {
            if let found = allIngredients.lazy.map({ $0.id == m[self.SCHEMA_COL_MATCHID] }).indexOf(true) {
                allIngredients[found].matchLevel = m[SCHEMA_COL_MATCHLEVEL]
                allCells.append(allIngredients[found])
            }
        }
        
        // Reset 'filteredCells' with new matches.
        filteredCells = allCells
        
        // This boolean will activate the colored backgrounds.
        // We only want to show the colors when viewing matches, not the list of all ingredients.
        viewingMatches = true
        
        // Show the new ingredients on our table with animation.
        animateTable()
        //        self.performSegueWithIdentifier("yourIdentifier", sender: self)
    }
    
    func loadIngredients() {
        
        // Connect to database.
        let dbpath = NSBundle.mainBundle().pathForResource("flavorbible", ofType: "db")
        do {
            db = try Connection(dbpath!)
        } catch {
            
        }
        
        // Define our tables.
        ingredientsTable = Table(SCHEMA_TABLE_INGREDIENTS)
        matchesTable = Table(SCHEMA_TABLE_MATCHES);
        
        // Create all Ingredients from database.
        for ingredient in db.prepare(ingredientsTable) {
            let possible_id : Int? = ingredient[SCHEMA_COL_ID]
            let possible_name : String? = ingredient[SCHEMA_COL_NAME]
            if let id = possible_id, let name = possible_name {
                if name.isEmpty == false {
                    let i = Ingredient(id: id, name: name)!
                    allIngredients.append(i)
                }
            }
        }
        
        // Showed the newly created Ingredient instances.
        showAllIngredients()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TABLE FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ---------------
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    // Function to animate all table cells on load.
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableWidth: CGFloat = tableView.bounds.size.width
        
        for i in cells {
            let cell: UITableViewCell = i 
            cell.transform = CGAffineTransformMakeTranslation(tableWidth, 0)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a 
            UIView.animateWithDuration(0.75, delay: 0.03 * Double(index), usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    func animateMenuTableView(dismiss: Bool) {
        menuTableView.reloadData()
        
        let cells = menuTableView.visibleCells
        let tableHeight: CGFloat = menuTableView.bounds.size.height
        
        let start = dismiss ? 0 : -1*tableHeight
        let end = dismiss ? tableHeight : 0
        
        for i in cells {
            let cell: UITableViewCell = i
            cell.transform = CGAffineTransformMakeTranslation(0, start)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a
            UIView.animateWithDuration(0.5, delay: 0.03 * Double(index), usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, end);
                }, completion: nil
//                { finished in
//                    if dismiss {
//                        self.menuTableView.hidden = true
//                    } else {
//                        self.menuTableView.hidden = false
//                    }
//                }
            )
            
            index += 1
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.tableView) {
            // Return the number of rows in the section.
            return filteredCells.count
        } else {
            return self.menuItems.count
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == self.tableView) {
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
            } else {
                cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
            }
            
            return cell
        } else {
            let cell: UITableViewCell = menuTableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel!.font = UIFont.fontAwesomeOfSize(15)
            cell.textLabel?.text = self.menuItems[indexPath.row].titleLabel!.text
            cell.textLabel?.textAlignment = .Center
            
//            cell.contentView.backgroundColor = UIColor.clearColor()
//            cell.backgroundColor = UIColor.clearColor()
//            tableView.backgroundColor = UIColor.clearColor()
            
            cell.backgroundColor = UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(1.0))
            
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if (tableView == self.tableView) {
            pushToHistory()
            
            // Get tapped ingredient.
            let ingredient = filteredCells[indexPath.row]
            
            showIngredient(ingredient)
        } else {
            print("You selected cell #\(indexPath.row)!")
        }

    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->
        [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            print("edit button tapped")
        }
        more.backgroundColor = UIColor(red: 249/255.0, green: 69/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
        
        let favorite = UITableViewRowAction(style: .Normal, title: "Yucky") { action, index in
            print("yucky button tapped")
        }
        favorite.backgroundColor = UIColor(red: 255/255.0, green: 109/255.0, blue: 69/255.0, alpha: CGFloat(0.3))
        
        let share = UITableViewRowAction(style: .Normal, title: "Yummy") { action, index in
            print("yummy button tapped")
        }
        share.backgroundColor = UIColor(red: 61/255.0, green: 235/255.0, blue: 64/255.0, alpha: CGFloat(0.3))
        
        return [share, favorite, more]
    }
//    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
//            // OPEN UIPresentationController HERE
//            let vc = UIViewController(nibName: nil, bundle: nil)
//            vc.view.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//            vc.view.backgroundColor = UIColor.orangeColor()
//            vc.modalPresentationStyle = .Popover
//            
//            let popover = vc.popoverPresentationController!
//            let cell = tableView.cellForRowAtIndexPath(indexPath)!
//            
//            var cellAbsolutePosition = cell.superview!.convertPoint(cell.frame.origin, toView: nil)
//            cellAbsolutePosition.x = cell.frame.width - 60
//            popover.sourceRect = CGRect(origin: cellAbsolutePosition, size: cell.frame.size)
//            popover.sourceView = tableView
//            
//            self.presentViewController(vc, animated: true, completion: nil)
//        }
//        return [edit]
//    }
    // ---------------------------------------------------------
    
    
    // SEARCHBAR FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // -------------------
    
    @IBAction func activateSearchBar(sender: AnyObject) {
//        self.searchBar.hidden = false
//        self.navigationItem.titleView = searchBar
//        self.navigationItem.setLeftBarButtonItems([goBackBtn], animated: true)
        showSearchBar()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideSearchBar()
        filterResults("")
    }
    
    func showSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.alpha = 0
        self.searchBar.hidden = false
//        self.navigationItem.titleView = searchBar
        self.navigationItem.setLeftBarButtonItems([goBackBtn], animated: true)
        
//        navigationItem.setLeftBarButtonItem(nil, animated: true)
        UIView.animateWithDuration(0.5, animations: {
            self.searchBar.alpha = 1
            }, completion: { finished in
                self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
//        navigationItem.setLeftBarButtonItem(searchBarButtonItem, animated: true)
//        logoImageView.alpha = 0
        var newTitle = ""
        if let curr = currentIngredient {
            newTitle = curr.name
        } else {
            newTitle = "All Ingredients"
        }
        
        self.searchBar.alpha = 1
        UIView.animateWithDuration(0.3, animations: {
//            self.navigationItem.titleView = self.logoImageView
//            self.logoImageView.alpha = 1

            self.searchBar.alpha = 0
            self.title = newTitle
            
            self.navigationItem.setLeftBarButtonItems([self.goBackBtn, self.searchBarActivateBtn], animated: true)

            }, completion: { finished in
                self.navigationItem.titleView = nil
        })
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterResults(searchText)
    }
    
    func filterResults(searchText: String) {
        filteredCells.removeAll()
        
        if searchText.isEmpty {
            filteredCells = allCells
            searchBar.text = ""
        } else {
            for ingredient in allCells {
                if ingredient.name.rangeOfString(searchText.lowercaseString) != nil {
                    filteredCells.append(ingredient)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    func _confidence(ups: Int, downs: Int) -> Double {
        let n = Double(ups) + Double(downs)
        
        if (n == 0) {
            return 0
        }
        
        let z = 1.0
        let phat = Double(ups) / n;
        
        let comp1 = phat*(1-phat)
        let comp2 = ((comp1+z*z/(4*n))/n)
        return sqrt(phat+z*z/(2*n)-z*comp2)/(1+z*z/n)
    }
    
    func confidence(ups: Int, downs: Int) -> Double {
        if (ups + downs == 0) {
            return 0
        } else {
            return _confidence(ups, downs: downs)
        }
    }
    // ---------------------------------------------------------

    
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
