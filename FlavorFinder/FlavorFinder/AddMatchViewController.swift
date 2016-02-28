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
    let ALREADY_EXISTS_SUFFIX = " is already a match!"
    let DEFAULT_PROMPT = "Which ingredient are you creating a new match for?"
    let PROMPT_PREFIX = "Which ingredient matches with "
    let PROMPT_SUFFIX = "?"
    let FEEDBACK_PREFIX = "New match created for "
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
                let alreadyExistsText = "\(firstIngredient!.name) + \(secondIngredient!.name)\(ALREADY_EXISTS_SUFFIX)"
                showFeedback(alreadyExistsText)
            } else {
                let matchMadeText = "\(FEEDBACK_PREFIX)\(firstIngredient!.name) + \(secondIngredient!.name)"
                addMatch(currentUser!, firstIngredient: firstIngredient!, secondIngredient: secondIngredient!)
                showFeedback(matchMadeText)
            }
            reset()
        } else { // first ingredient of the match was selected
            firstIngredient = selected
            promptLabel.text = "\(PROMPT_PREFIX)\(firstIngredient!.name)\(PROMPT_SUFFIX)"
            ingredientSearchBar?.text = ""
            searchTable?.hidden = true
        }
    }
    
    // MARK: Other functions ---------------------------------------------------
    
    /* showFeedback
    - shows textual feedback to the user about success/failure of operation
    */
    func showFeedback(message: String) {
        self.navigationController?.view.makeToast(message, duration: TOAST_DURATION, position: .AlmostBottom)
    }
    
    /* reset
    - resets the view after a match has been added
    */
    func reset() {
        promptLabel.text = DEFAULT_PROMPT
        firstIngredient = nil
        secondIngredient = nil
        ingredientSearchBar?.text = ""
        searchTable?.hidden = true
    }
    
}