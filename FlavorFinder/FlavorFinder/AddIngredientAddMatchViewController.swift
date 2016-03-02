//
//  AddIngredientAddMatchViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/29/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit

class AddIngredientAddMatchViewController : AddMatchPrototypeViewController {
    
    // MARK: Properties:
    let pageTitle = "Add Matches for New Ingredient"
    let FEEDBACK_PREFIX = "Match with "
    let FEEDBACK_SUFFIX = " proposed"
    let SUCCESS_SUFFIX = " & its matches will be added to the database!" // some lag
    var proposedMatches = [PFIngredient]()
    
    // MARK: Connections:
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var chooseIngredientSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: Actions:
    
    @IBAction func submitButtonWasPressed(sender: AnyObject) {
        
        if currentUser == nil || firstIngredient == nil {
            self.navigationController?.popToRootViewControllerAnimated(true)
            print("ERROR: Invalid attempt to access add ingredient add match page.")
        }
        
        let ingredient = addIngredient((firstIngredient?.name.lowercaseString)!, isDairy: (firstIngredient?.isDairy)!, isNuts: (firstIngredient?.isNuts)!, isVege: (firstIngredient?.isVege)!)
        
        for match in proposedMatches {
            addMatch(currentUser!, firstIngredient: ingredient, secondIngredient: match)
        }
        
        showFeedback("\(ingredient.name)\(SUCCESS_SUFFIX)", vc: self)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: Override methods:
    
    /* viewDidLoad:
    */
    override func viewDidLoad() {
        
        if currentUser == nil || firstIngredient == nil {
            self.navigationController?.popToRootViewControllerAnimated(true)
            print("ERROR: Invalid attempt to access add ingredient add match page.")
        }
        
        // Assign values to parent class variables
        ingredientSearchBar = chooseIngredientSearchBar
        searchTable = searchTableView
        navTitle = pageTitle
        
        // Deal with subviews etc.
        promptLabel.text = "\(PROMPT_PREFIX)\(firstIngredient!.name)\(PROMPT_SUFFIX)"
        promptLabel.hidden = false
        submitButton.enabled = false
        
        // Call super
        super.viewDidLoad()
        
        // grey background:
        view.backgroundColor = BACKGROUND_COLOR
    }
    
    // MARK: Overriding parent class functions ------------------------------
    
    /* gotSelectedIngredient
    - handle selection of ingredient w.r.t. creating a new match
    */
    override func gotSelectedIngredient(selected: PFIngredient) {
        // check that we're logged in
        if currentUser == nil {
            errorLoggedOut()
            return
        }
        // save the proposed match
        proposedMatches.append(selected)
        showFeedback("\(FEEDBACK_PREFIX)\(selected.name)\(FEEDBACK_SUFFIX)", vc: self)
        // allow user to submit the new ingredient now that we have at least 1 match
        if !(proposedMatches.isEmpty) {
            submitButton.enabled = true
        }
    }
    
}