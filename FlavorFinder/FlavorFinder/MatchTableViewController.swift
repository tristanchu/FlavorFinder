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

class MatchTableViewController: UITableViewController, UISearchBarDelegate {
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
    
    var allIngredients = [Ingredient]() // Array of all ingredients from database.
    var allCells = [Ingredient]()       // Array of all cells that CAN be displayed.
    var filteredCells = [Ingredient]()  // Array of all cells that ARE displayed (filtered version of 'allCells').
    var viewingMatches = false          // Activates colored backgrounds. Only want to show colors when viewing matches, not all ingredients.
    var currentIngredient : Ingredient? // Stores the ingredient being viewed (nil for all ingredients).
    
    var history = Stack<Ingredient?>()  // Used for going backward.
    var future = Stack<Ingredient?>()   // Used for going forward.
    
    var menuTableView: UITableView = UITableView()
    var menuTableItems = [  String.fontAwesomeIconWithName(.User) + " Profile",
                            String.fontAwesomeIconWithName(.Cutlery) + " Ingredients",
                            String.fontAwesomeIconWithName(.SignOut) + " Sign Out"
                         ]
    var menuBtn: UIButton = UIButton()
    var menuBarBtn: UIBarButtonItem = UIBarButtonItem()
    
    var goBackBtn: UIBarButtonItem = UIBarButtonItem()
    var goForwardBtn: UIBarButtonItem = UIBarButtonItem()

    var searchBarActivateBtn: UIBarButtonItem = UIBarButtonItem()
    lazy var searchBar = UISearchBar(frame: CGRectMake(0, 0, 0, 0))
    
    let SEGUE_LOGOUT = "segueLogout"
    let TITLE_ALL_INGREDIENTS = "All Ingredients"
    let CELLIDENTIFIER_MENU = "menuCell"
    let CELLIDENTIFIER_MATCH = "MatchTableViewCell"
    
    let BUTTON_COLOR = UIColor(red: 165/255.0, green: 242/255.0, blue: 216/255.0, alpha: CGFloat(1))
    
    @IBOutlet var matchTableView: UITableView!
    
    // NAVI FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // --------------
    func goBackBtnClicked() {
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
    
    func goForwardBtnClicked() {
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
    
    // SETUP FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ---------------
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.hidden = true
        searchBar.setShowsCancelButton(true, animated: false)
    }
    
    func configureNavigationBar() {
        // Disable buttons by default.
        goBackBtn.enabled = false
        goForwardBtn.enabled = false
        
        var attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        goBackBtn.setTitleTextAttributes(attributes, forState: .Normal)
        goBackBtn.title = String.fontAwesomeIconWithName(.ChevronLeft)
        goBackBtn.tintColor = BUTTON_COLOR
        goBackBtn.target = self
        goBackBtn.action = "goBackBtnClicked"
        
        attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        goForwardBtn.setTitleTextAttributes(attributes, forState: .Normal)
        goForwardBtn.title = String.fontAwesomeIconWithName(.ChevronRight)
        goForwardBtn.tintColor = BUTTON_COLOR
        goForwardBtn.target = self
        goForwardBtn.action = "goForwardBtnClicked"
        
        attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        searchBarActivateBtn.setTitleTextAttributes(attributes, forState: .Normal)
        searchBarActivateBtn.title = String.fontAwesomeIconWithName(.Search)
        searchBarActivateBtn.tintColor = BUTTON_COLOR
        searchBarActivateBtn.target = self
        searchBarActivateBtn.action = "searchBarActivateBtnClicked"
        
        attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        menuBarBtn.setTitleTextAttributes(attributes, forState: .Normal)
        menuBarBtn.title = String.fontAwesomeIconWithName(.Bars)
        menuBarBtn.tintColor = BUTTON_COLOR
        menuBarBtn.target = self
        menuBarBtn.action = "menuBtnClicked"
        
        self.navigationItem.setLeftBarButtonItems([self.goBackBtn, self.searchBarActivateBtn], animated: true)
        self.navigationItem.setRightBarButtonItems([self.goForwardBtn, self.menuBarBtn], animated: true)
    }
    
    func configureMenuTableView() {
        menuTableView.frame = CGRectMake(0, 0, self.view.frame.width, 200);
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER_MENU)
        menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        menuTableView.tableFooterView = UIView.init(frame: CGRectZero)
        menuTableView.tableFooterView!.hidden = true
        menuTableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(menuTableView)
        menuTableView.hidden = true
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // Update position of menu so it stays on screen.
        var frame = self.menuTableView.frame
        frame.origin.y = UIApplication.sharedApplication().statusBarFrame.size.height +
                            (self.navigationController?.navigationBar.frame.height)! +
                            scrollView.contentOffset.y
        self.menuTableView.frame = frame
        self.view.bringSubviewToFront(menuTableView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        configureNavigationBar()
        configureMenuTableView()
        
        loadIngredients()           // Show all ingredients to start.
    }
    
    func menuBtnClicked() {
        print("menuBtn clicked.")
        if (menuTableView.hidden) {
            menuTableView.hidden = false
            menuBarBtn.title = String.fontAwesomeIconWithName(.Times)
            animateMenuTableView(false)
        } else {
//            animateMenuTableView(true)
            menuTableView.hidden = true
            menuBarBtn.title = String.fontAwesomeIconWithName(.Bars)
        }
    }
    
    func showAllIngredients() {
        viewingMatches = false
        allCells = allIngredients
        filteredCells = allIngredients
        self.title = TITLE_ALL_INGREDIENTS
        currentIngredient = nil
        
        animateTable()
    }
    
    func showIngredient(ingredient: Ingredient) {
        currentIngredient = ingredient
        self.title = ingredient.name    // Set navigation title to ingredient's name.
        let matches = matchesTable.filter(SCHEMA_COL_ID == ingredient.id)   // Get all the match ids of matches for this ingredient.
        
        // Reset 'allCells' with the ingredients that have those match ids.
        allCells.removeAll()
        for m in db.prepare(matches) {
            if let found = allIngredients.lazy.map({ $0.id == m[self.SCHEMA_COL_MATCHID] }).indexOf(true) {
                allIngredients[found].matchLevel = m[SCHEMA_COL_MATCHLEVEL]
                allCells.append(allIngredients[found])
            }
        }
        
        filteredCells = allCells        // Reset 'filteredCells' with new matches.
        viewingMatches = true           // Activates colored backgrounds. Only want to show colors when viewing matches, not all ingredients.
        animateTable()                  // Show the new ingredients on our table with animation.
    }
    
    func loadIngredients() {
        
        // Connect to database.
        let dbpath = NSBundle.mainBundle().pathForResource("flavorbible", ofType: "db")
        do {
            db = try Connection(dbpath!)
        } catch {}
        
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
            return self.menuTableItems.count
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == self.tableView) {
            let cellIdentifier = CELLIDENTIFIER_MATCH
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
            let cell: UITableViewCell = menuTableView.dequeueReusableCellWithIdentifier(CELLIDENTIFIER_MENU, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel!.font = UIFont.fontAwesomeOfSize(15)
            cell.textLabel?.text = self.menuTableItems[indexPath.row]
            cell.textLabel?.textAlignment = .Center
            
            switch indexPath.row {
            case 0:
                cell.backgroundColor = UIColor(red: 59/255.0, green: 247/255.0, blue: 194/255.0, alpha: CGFloat(1.0))
                break
            case 1:
                cell.backgroundColor = UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(1.0))
                break
            case 2:
                cell.backgroundColor = UIColor(red: 227/255.0, green: 78/255.0, blue: 59/255.0, alpha: CGFloat(1.0))
              
                break
            default:
                cell.backgroundColor = UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(1.0))
                break
            }

            
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if (tableView == self.tableView) {
            pushToHistory()                                                           // Push current ingredient to history stack.
            tableView.contentOffset = CGPointMake(0, 0 - tableView.contentInset.top); // Reset scroll position.
            let ingredient = filteredCells[indexPath.row]                             // Get tapped ingredient.
            showIngredient(ingredient)
        } else {
            print("You selected cell #\(indexPath.row)!")
            if (indexPath.row == 2) {
                self.performSegueWithIdentifier(SEGUE_LOGOUT, sender: self)
            }
        }

    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if (tableView == self.tableView) {
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
        } else {
            return []
        }
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
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
    func searchBarActivateBtnClicked() {
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
        self.navigationItem.setLeftBarButtonItems([goBackBtn], animated: true)
        
        UIView.animateWithDuration(0.5, animations: {
            self.searchBar.alpha = 1
            }, completion: { finished in
                self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        var newTitle = ""
        if let curr = currentIngredient {
            newTitle = curr.name
        } else {
            newTitle = TITLE_ALL_INGREDIENTS
        }
        
        self.searchBar.alpha = 1
        UIView.animateWithDuration(0.3, animations: {
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
