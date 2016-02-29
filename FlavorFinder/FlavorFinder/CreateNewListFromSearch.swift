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
        if newListNameTextField.text != nil && newListNameTextField.text != "" {
            let newName = newListNameTextField.text!
            var list = [PFIngredient]()
            if !currentIngredientToAdd.isEmpty {
                for ingredient in currentSearch {list.append(ingredient)}
                createIngredientList(currentUser!, title: newName, ingredients: list)
                makeListToast(newName, iList: currentIngredientToAdd)
                currentIngredientToAdd = []
            } else {
                for ingredient in currentSearch {list.append(ingredient)}
                createIngredientList(currentUser!, title: newName, ingredients: list)
                makeListToast(newName, iList: currentSearch)
            }
        }
        
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
    
    // MARK: Toast Message - --------------------------------------------------
    /* addToListMsg
    - creates the message "Added __, __, __ to listname"
    */
    func addToListMsg(listName: String, ingredients: [PFIngredient]) -> String {
        if ingredients.count == 1 {
            return "Added \(ingredients[0].name) to \(listName)"
        }
        let names: [String] = ingredients.map { return $0.name }
        let ingredientsString = names.joinWithSeparator(", ")
        return "Added \(ingredientsString) to \(listName)"
    }
    
    /* makeListToast
    - just to clean up the above code.
    */
    func makeListToast(listTitle: String, iList: [PFIngredient]) {
        self.navigationController?.view.makeToast(addToListMsg(
            listTitle, ingredients: iList),
            duration: TOAST_DURATION, position: .AlmostBottom)
    }
}
