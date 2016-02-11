//
//  EditListPage.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/7/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class EditListPage: SearchIngredientsViewController, UITextFieldDelegate {
    
    // MARK: Properties:
    var ingredientList = [PFIngredient]()
    var listObject: PFObject!
    var listTitle = ""

    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"

    // Visual related:
    let pageTitle = "Edit List"
    let alreadyContains = " is already in your list"

    // MARK: connections:
    @IBOutlet weak var listNamePromptLabel: UILabel!
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var newNamePromptLabel: UILabel!
    @IBOutlet weak var addIngredientPromptLabel: UILabel!

    @IBOutlet weak var newNameTextField: UITextField!
    @IBOutlet weak var addIngredientSearchBar: UISearchBar!

    @IBOutlet weak var searchTableView: UITableView!

    @IBAction func submitAction(sender: AnyObject) {
        if newNameTextField.text != nil && newNameTextField.text != "" {
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
        // Assign values to parent class variables
        ingredientSearchBar = addIngredientSearchBar
        searchTable = searchTableView
        navTitle = pageTitle
        
        // Call super
        super.viewDidLoad()

        // Set title label to list title:
        listTitleLabel.text = listTitle

        // set up text field
        newNameTextField.delegate = self
        newNameTextField.setTextLeftPadding(5)
    }
    
    // MARK: Overriding parent class functions
    
    /* gotSelectedIngredient
    - handle selection of ingredient in search: add to list if not already in list
    */
    override func gotSelectedIngredient(selected: PFIngredient) {
        var userList = listObject.objectForKey(ingredientsColumnName) as! [PFIngredient]
        if userList.contains(selected) && selected.isDataAvailable() {
            addIngredientPromptLabel.text = "\(selected.name)\(alreadyContains)"
        } else {
            userList.append(selected)
            listObject.setObject(userList, forKey: ingredientsColumnName)
            listObject.saveInBackground()
            if selected.isDataAvailable() {
                addIngredientPromptLabel.text = "Added \(selected.name)"
            }
        }
    }
    
}