//
//  CreateNewListFromSearch.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/28/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class CreateNewListFromSearch: SearchIngredientsViewController, UITextFieldDelegate {
    
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
    let pageTitle = "Add To New List"
    
    //
    @IBOutlet weak var createNewListPromptLabel: UILabel!
    @IBOutlet weak var newListNameTextField: UITextField!
    
    @IBOutlet weak var createNewListBtn: UIButton!
    @IBOutlet weak var cancelNewListBtn: UIButton!
    
    @IBAction func createNewListBtnAction(sender: AnyObject) {
        if currentIngredientToAdd.isEmpty {
            print("Adding search")
        } else {
            print("Adding ingredient")
        }
        // Remember to empty currentIngredientToAdd
        currentIngredientToAdd = []
    
        // go back to search:
        let numControllers = self.navigationController?.viewControllers.count
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[numControllers! - 3])!, animated: true)
    }
    
    
    @IBAction func cancelNewListBtnAction(sender: AnyObject) {
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
        newListNameTextField.delegate = self
        newListNameTextField.setTextLeftPadding(5)
    }
}
