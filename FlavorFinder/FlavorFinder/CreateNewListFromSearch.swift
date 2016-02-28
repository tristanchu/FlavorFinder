//
//  CreateNewListFromSearch.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/28/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class CreateNewListFromSearch: SearchIngredientsViewController {
    
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
    
    
    
    /* viewDidLoad:
    Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        // Assign values to parent class variables
        navTitle = pageTitle
        
        // Call super
        super.viewDidLoad()
        
        // set up text field
//        nameListTextField.delegate = self
//        nameListTextField.setTextLeftPadding(5)
    }
}
