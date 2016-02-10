//
//  EditListPage.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/7/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class EditListPage: UIViewController, UITextFieldDelegate,
    UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties:
    var ingredientList = [PFIngredient]()
    var listObject: PFObject!
    var listTitle = ""

    // adding ingredient related:
    var activeSearch : Bool = false;
    var allIngredients : [PFIngredient]? // set on load
    var filteredResults : [PFIngredient] = []
    let CELL_IDENTIFIER = "searchResultCell"

    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"

    // Visual related:
    let pageTitle = "Edit List"
    let alreadyContains = " is already in your list"

    // Navigation:
    var backBtn: UIBarButtonItem = UIBarButtonItem()
    let backBtnAction = "backBtnClicked:"
    let backBtnString = String.fontAwesomeIconWithName(.ChevronLeft) + " Back"

    // MARK: connections:
    @IBOutlet weak var listNamePromptLabel: UILabel!
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var newNamePromptLabel: UILabel!
    @IBOutlet weak var addIngredientPromptLabel: UILabel!

    @IBOutlet weak var newNameTextField: UITextField!
    @IBOutlet weak var addIngredientSearchBar: UISearchBar!

    @IBOutlet weak var searchTableView: UITableView!

    @IBAction func submitAction(sender: AnyObject) {
        if newNameTextField.text != nil {
            listObject.setObject(newNameTextField.text!, forKey: ListTitleColumnName)
            listTitleLabel.text = newNameTextField.text
            listObject.saveInBackground()
        }
    }

    @IBAction func cancelAction(sender: AnyObject) {
        newNameTextField.text = ""
    }


    // MARK: Override methods: ----------------------------------------------


    /* viewDidLoad:
    Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title label to list title:
        listTitleLabel.text = listTitle

        // set up text field
        newNameTextField.delegate = self
        newNameTextField.setTextLeftPadding(5)

        // set up delegates search bar and table view:
        addIngredientSearchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self

        // Navigation buttons:
        setUpBackButton()
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
                    [self.backBtn], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                navi.reset_navigationBar()
                self.tabBarController?.navigationItem.title = "\(self.pageTitle)"
                self.backBtn.enabled = true
        }

        // Hide search bar results on load:
        searchTableView.hidden = true
    }

    // MARL: UITableViewDataSource protocol functions --------------------
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        activeSearch = true;
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        activeSearch = false;
        searchTableView.hidden = true
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        activeSearch = false;
        searchTableView.hidden = true
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        activeSearch = false;
        searchTableView.hidden = true
    }

    /* searchBar - for UITableViewDataSource
    gives table view ingredients filtered by search:
    */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // fills filteredResults based on text entered
        if let allIngredients = _allIngredients as? [PFIngredient] {
            filteredResults = allIngredients.filter({ (ingredient) -> Bool in
                let tmp: PFObject = ingredient
                let range = tmp[_s_name].rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
            if filteredResults.isEmpty {
                activeSearch = false
                searchTableView.hidden = true
            } else {
                activeSearch = true
                searchTableView.hidden = false
            }
            self.searchTableView.reloadData()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /* tableView -- UITableViewDelegate func
    - returns number of rows to display
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(activeSearch) {
            return filteredResults.count
        }
        // have no cells if no search:
        return 0;
    }

    /* tableView - UITableViewDelegate func
    - cell logic
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCellWithIdentifier(
            CELL_IDENTIFIER, forIndexPath: indexPath)
        // set cell label:
        cell.textLabel?.text = filteredResults[indexPath.item].name
        // Give cell a chevron:
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell;
    }

    /* tableView -> happens on selection of row
    - sets selected row to current search
    - goes to search result view
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // make selected row the current search:
        let selected : PFIngredient = filteredResults[indexPath.row]
        var userList = listObject.objectForKey(ingredientsColumnName) as! [PFIngredient]
        if userList.contains(selected) {
            addIngredientPromptLabel.text = "\(selected.name)\(alreadyContains)"
        } else {
            userList.append(selected)
            listObject.setObject(userList, forKey: ingredientsColumnName)
            listObject.saveInBackground()
            addIngredientPromptLabel.text = "Added \(selected.name)"
        }
    }


    // MARK: Back Button Functions -----------------------------------------


    /* setUpBackButton
    sets up the back button visuals for navigation
    */
    func setUpBackButton() {
        backBtn.setTitleTextAttributes(attributes, forState: .Normal)
        backBtn.title = self.backBtnString
        backBtn.tintColor = NAVI_BUTTON_COLOR
        backBtn.target = self
        backBtn.action = "backBtnClicked"  // refers to: backBtnClicked()
    }

    /* backBtnClicked
    - action for back button
    */
    func backBtnClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
}