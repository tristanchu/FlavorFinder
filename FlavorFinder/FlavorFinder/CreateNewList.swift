//
//  CreateNewList.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/24/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class CreateNewList: SearchIngredientsViewController, UITextFieldDelegate {
    
    // MARK: Properties:
    var ingredientList = [PFIngredient]()
    var listObject: PFObject!
    var listTitle = ""
    var userLists = [PFObject]()
    
    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"
    
    // Visual related:
    let pageTitle = "Rename List"
    
    
    @IBOutlet weak var createListPromptLabel: UILabel!
    
    @IBOutlet weak var nameListTextField: UITextField!
    
    @IBOutlet weak var createListBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    @IBAction func createListBtnAction(sender: AnyObject) {
        if nameListTextField.text != nil && nameListTextField.text != "" {
            let newList = createIngredientList(
                currentUser!, title: nameListTextField.text!,
                ingredients: []) as PFObject
            // add list to user's list:
            self.userLists.append(newList)
            // go back to list page:
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func cancelBtnAction(sender: AnyObject) {
        // go back to list page:
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    /* viewDidLoad:
    Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        // Assign values to parent class variables
        navTitle = pageTitle
        
        // Call super
        super.viewDidLoad()
        
        // set up text field
        nameListTextField.delegate = self
        nameListTextField.setTextLeftPadding(5)
    }
    
    
}
