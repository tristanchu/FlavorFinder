//
//  AddIngredientViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/28/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse

class AddIngredientViewController : GotNaviViewController {
    
    // MARK: Properties
    
    let pageTitle = "Add New Ingredient"
    let WARNING_PREFIX = "DOUBLE-CHECK that you are proposing an ingredient that isn't: "
    let WARNING_DIVIDER = ", "
    var name : String?
    
    // Outlets
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    // MARK: Actions
    
    /* nameWasEntered
    - called when user exits text field
    - handles input of proposed ingredient name
    */
    @IBAction func nameWasEntered(sender: UITextField) {
        if !(sender.hasText()) {
            reset()
            return
        }
        name = sender.text
        gotNameFeedback()
    }
    
    // MARK: Override functions
    
    /* viewDidLoad
    - override: setup when view loaded
    */
    override func viewDidLoad() {
        navTitle = pageTitle
        super.viewDidLoad()
    }
    
    /* viewDidAppear
    - override: called when view appears to user
    */
    override func viewDidAppear(animated: Bool) {
        reset()
        super.viewDidAppear(animated)
    }
    
    // MARK: Other functions
    
    /* reset
    - resets default page view to clear form
    */
    func reset() {
        warningLabel.hidden = false
    }
    
    /* gotNameFeedback
    - provides feedback having gotten an ingredient name from the user
    */
    func gotNameFeedback() {
        if name == nil {
            return
        }
        
        // text field updates
        nameTextField.textColor = UIColor.blueColor() // should be standardized
        nameTextField.textAlignment = NSTextAlignment.Center
        nameTextField.enabled = false
        
        // check for existing ingredients and warn
        let possibleIngredients = getPossibleIngredients(name!)
        if possibleIngredients.isEmpty {
            warningLabel.hidden = true
        } else {
            var warningIngredientList = ""
            for ingredient in possibleIngredients {
                warningIngredientList.appendContentsOf("\(ingredient.name)\(WARNING_DIVIDER)")
            }
            let range = warningIngredientList.endIndex.advancedBy(
                -1 * WARNING_DIVIDER.characters.count)..<warningIngredientList.endIndex
            warningIngredientList.removeRange(range)
            warningLabel.text = "\(WARNING_PREFIX)\(warningIngredientList)"
        }
    }
    
}