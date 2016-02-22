//
//  AddToListPage.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/21/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class AddToListPage: SearchIngredientsViewController, UITextFieldDelegate {
    
    // MARK: Properties:
    var ingredientList = [PFIngredient]()
    var listObject: PFObject!
    var listTitle = ""
    
    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"
    
    
    // Visual:
    let pageTitle = "Add Ingredient"
    let addIngredientPrompt = "Add an ingredient to "
    let alreadyContains = " is already in your list"
    
    // Navigation:
    var cancelBtn: UIBarButtonItem = UIBarButtonItem()
    let cancelBtnAction = "cancelBtnClicked:"
    let cancelBtnString = String.fontAwesomeIconWithName(.ChevronLeft) + " Cancel"
    
    // Outlets:
    @IBOutlet weak var addIngredientPromptLabel: UILabel!
    
    @IBOutlet weak var addIngredientSearchBar: UISearchBar!
    @IBOutlet weak var addIngredientTableView: UITableView!
    
    
    // MARK: Override methods: ------------
    /* viewDidLoad:
    Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        // Assign values to parent class variables:
        ingredientSearchBar = addIngredientSearchBar
        searchTable = addIngredientTableView
        
        // set ingredient prompt to the use list name:
        addIngredientPromptLabel.text = "\(addIngredientPrompt)\(listTitle)"
        
        super.viewDidLoad()
        
        // Navigation Visuals:
        setUpCancelButton()
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
                    [self.cancelBtn], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                navi.reset_navigationBar()
                self.tabBarController?.navigationItem.title = pageTitle
                self.cancelBtn.enabled = true
        }
        
    }
    
    
    // MARK: Back Button Functions -------------------------------------
    
    /* setUpBackButton
    sets up the back button visuals for navigation
    */
    func setUpCancelButton() {
        cancelBtn.setTitleTextAttributes(attributes, forState: .Normal)
        cancelBtn.title = self.backBtnString
        cancelBtn.tintColor = NAVI_BUTTON_COLOR
        cancelBtn.target = self
        cancelBtn.action = "cancelBtnClicked"  // refers to: backBtnClicked()
    }
    
    /* backBtnClicked
    - action for back button
    */
    func cancelBtnClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Overriding parent class functions
    
    /* gotSelectedIngredient
    - handle selection of ingredient in search: add to list if not already in list
    */
    override func gotSelectedIngredient(selected: PFIngredient) {
        var userList = listObject.objectForKey(ingredientsColumnName) as! [PFIngredient]
        if !(userList.contains(selected) && selected.isDataAvailable()) {
            // add ingredient to list:
            userList.append(selected)
            listObject.setObject(userList, forKey: ingredientsColumnName)
            listObject.saveInBackground()
            
            // return to list page
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    

}
