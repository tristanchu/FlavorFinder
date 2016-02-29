//
//  AddMatchPrototypeViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/29/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

class AddMatchPrototypeViewController : SearchIngredientsViewController {
    
    // MARK: Properties
    
    let PROMPT_PREFIX = "Which ingredient matches with "
    let PROMPT_SUFFIX = "?"
    
    var firstIngredient : PFIngredient?
    var secondIngredient : PFIngredient?
    
    // MARK: Functions
    
    /* errorLoggedOut
    - handles what to do when you've tried to add a match, but you're logged out!
    - this should never actually be called--if so, some login logic somewhere got broken
    */
    func errorLoggedOut() {
        print("ERROR: Cannot propose a match without being logged in!")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}