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
    let pageTitle = "Rename List"
    let alreadyContains = " is already in your list"

    // MARK: connections:
    @IBOutlet weak var listNamePromptLabel: UILabel!
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var newNamePromptLabel: UILabel!

    @IBOutlet weak var newNameTextField: UITextField!

    
    
    @IBOutlet weak var renameListButton: UIButton!
    @IBOutlet weak var cancelRenameButton: UIButton!
    
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
        navTitle = pageTitle
        
        // Call super
        super.viewDidLoad()

        // Set title label to list title:
        listTitleLabel.text = listTitle

        // set up text field
        newNameTextField.delegate = self
        newNameTextField.setTextLeftPadding(5)
        
        // button borders:
        setDefaultButtonUI(renameListButton)
        setSecondaryButtonUI(cancelRenameButton)
    }
       
}