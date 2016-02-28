//
//  AddMatchViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/27/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit

class AddMatchViewController : SearchIngredientsViewController {
    
    // MARK: Properties:
    let pageTitle = "Add A New Match"
    let alreadyExistsText = " is already a match!"
    let defaultPrompt = "Which ingredient are you creating a new match for?"
    let promptPrefix = "Which ingredient matches with "
    let promptSuffix = "?"
    var firstIngredient : PFIngredient?
    var secondIngredient : PFIngredient?
    
    // MARK: connections:
    @IBOutlet weak var chooseIngredientSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var promptLabel: UILabel!
    
    // MARK: Override methods: ----------------------------------------------
    
    /* viewDidLoad:
    */
    override func viewDidLoad() {
        // Assign values to parent class variables
        ingredientSearchBar = chooseIngredientSearchBar
        searchTable = searchTableView
        navTitle = pageTitle
        
        // Call super
        super.viewDidLoad()
    }
    
    /* viewDidAppear:
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reset()
    }
    
    // MARK: Overriding parent class functions ------------------------------
    
    /* gotSelectedIngredient
    - handle selection of ingredient w.r.t. creating a new match
    */
    override func gotSelectedIngredient(selected: PFIngredient) {
        
        if currentUser == nil {
            print("ERROR: Cannot propose a match without being logged in!")
            return
        }
        
        if let _ = firstIngredient { // try to create a match
            secondIngredient = selected
            if let _ = getMatchForTwoIngredients(firstIngredient!, secondIngredient: secondIngredient!) {
                print("the match already exists") // use feedback system
            } else {
                addMatch(currentUser!, firstIngredient: firstIngredient!, secondIngredient: secondIngredient!)
                print("match added") // use feedback system
            }
            reset()
        } else {
            // indicate selection
            firstIngredient = selected
            promptLabel.text = "\(promptPrefix)\(firstIngredient!.name)\(promptSuffix)"
            ingredientSearchBar?.text = ""
            searchTable?.hidden = true
        }
    }
    
    // MARK: Other functions ---------------------------------------------------
    
    /* reset
    - resets the view after a match has been added
    */
    func reset() {
        promptLabel.text = defaultPrompt
        firstIngredient = nil
        secondIngredient = nil
        ingredientSearchBar?.text = ""
        searchTable?.hidden = true
    }
    
}