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

class AddIngredientViewController : GotNaviViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    let pageTitle = "Add New Ingredient"
    let nextPageSegue = "segueAddIngredientToMatch"
    let WARNING_PREFIX = "Please confirm that the proposed ingredient isn't: "
    let WARNING_DIVIDER = ", "
    let CELL_IDENTIFIER = "setFilterCell"
    let MIN_CHARS = 3
    let MAX_CHARS = 40
    var name : String?
    var warningDefaultText : String?
    
    // Outlets
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var filterTable: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
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
        name = sender.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        gotNameFeedback()
    }
    
    /* nextButtonWasPressed
    - called when user touches up on next button
    - moves user to next part of the form
    */
    @IBAction func nextButtonWasPressed() {
        performSegueWithIdentifier(nextPageSegue, sender: self)
    }
    
    /* nextButtonWasPressed
    - called when user touches up on confirm button
    - hides warning message and filter selection part of form
    */
    @IBAction func confirmButtonWasPressed() {
        confirmButton.hidden = true
        warningLabel.hidden = true
        enableForm()
    }
    
    // MARK: Override functions
    
    /* viewDidLoad
    - override: setup when view loaded
    */
    override func viewDidLoad() {
        navTitle = pageTitle
        filterTable.delegate = self
        filterTable.dataSource = self
        setUpFilterTable()
        warningDefaultText = warningLabel.text
        super.viewDidLoad()
    }
    
    /* viewDidAppear
    - override: called when view appears to user
    */
    override func viewDidAppear(animated: Bool) {
        reset()
        super.viewDidAppear(animated)
    }
    
    // MARK: UITableViewDataSource protocol functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /* tableView -- UITableViewDelegate func
    - returns number of rows to display
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // magic number :( how many filters we are making demo-able
    }
    
    
    /* tableView - UITableViewDelegate func
    - cell logic
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = filterTable.dequeueReusableCellWithIdentifier(
            CELL_IDENTIFIER, forIndexPath: indexPath)
        // set cell label:
        cell.textLabel?.text = "This is a filter"
        return cell
    }
    
    /* tableView -> happens on selection of row
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}
    
    // MARK: Other functions
    
    /* setUpFilterTable
    - handles setup for filter table
    - whenever possible, these things should be set in storyboard instead of programmatically
    */
    func setUpFilterTable() {}
    
    /* reset
    - resets default page view to clear form
    */
    func reset() {
        nameTextField.text = ""
        nameTextField.textColor = UIColor.blackColor() // should be standardized
        nameTextField.textAlignment = NSTextAlignment.Left
        nameTextField.enabled = true
        warningLabel.text = warningDefaultText
        warningLabel.hidden = false
        filterTable.hidden = true
        nextButton.hidden = true
        confirmButton.hidden = true
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
        
        // check for existing ingredients and warn, or cancel
        let possibleIngredients = getPossibleIngredients(name!)
        if possibleIngredients.isEmpty {
            enableForm()
        } else {
            getNameConfirmation(possibleIngredients)
        }
    }
    
    /* enableForm
    - enables the rest of the add ingredient form once user has confirmed ingredient name
    */
    func enableForm() {
        warningLabel.hidden = true
        filterTable.hidden = false
        nextButton.hidden = false
    }
    
    /* getNameConfirmation
    - button appears to require user to certify that ingredient is not pre-existing
    - text appears to warn user of possible pre-existing matches
    - or, if name is exact match, or too short/long, form resets
    */
    func getNameConfirmation(possibleIngredients: [PFIngredient]) {
        
        if name?.characters.count < MIN_CHARS || name?.characters.count > MAX_CHARS {
            showFeedback("Ingredient name must be between \(MIN_CHARS) and \(MAX_CHARS) characters", vc: self)
            reset()
            return
        }
        
        for ingredient in possibleIngredients {
            if ingredient.name.lowercaseString == name?.lowercaseString {
                showFeedback("\(name!) is already an ingredient!", vc: self)
                reset()
                return
            }
        }
        
        var warningIngredientList = ""
        for ingredient in possibleIngredients {
            warningIngredientList.appendContentsOf("\(ingredient.name)\(WARNING_DIVIDER)")
        }
        let range = warningIngredientList.endIndex.advancedBy(
            -1 * WARNING_DIVIDER.characters.count)..<warningIngredientList.endIndex
        warningIngredientList.removeRange(range)
        warningLabel.text = "\(WARNING_PREFIX)\(warningIngredientList)"
        confirmButton.hidden = false
    }
}