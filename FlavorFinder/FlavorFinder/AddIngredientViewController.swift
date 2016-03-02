//
//  AddIngredientViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/28/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit

class AddIngredientViewController : GotNaviViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    let pageTitle = "Add New Ingredient"
    let nextPageSegue = "segueAddIngredientToMatch"
    let WARNING_PREFIX = "Please confirm that the proposed ingredient isn't: "
    let WARNING_DIVIDER = ", "
    let CELL_IDENTIFIER = "setFilterCell"
    let MIN_CHARS = 3
    let MAX_CHARS = 40
    var filtersOn = [
        F_DAIRY : false,
        F_VEG : false,
        F_NUTS : false
    ]
    let filtersText = [
        F_DAIRY : "a dairy product?",
        F_VEG : "vegetarian?",
        F_NUTS : "a nut or nut product?"
    ]
    let filtersImage = [
        F_DAIRY : "Dairy",
        F_VEG : "Vegetarian",
        F_NUTS : "Nuts"
    ]
    let filterSwitchSelector : Selector = "filterSwitchWasChanged:"
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
        
        view.backgroundColor = BACKGROUND_COLOR
        
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
            CELL_IDENTIFIER, forIndexPath: indexPath) as! SetFilterTableViewCell
        
        cell.filterSwitch.addTarget(self, action: filterSwitchSelector, forControlEvents: UIControlEvents.ValueChanged)
        
        var text = ""
        var image = ""
        switch indexPath.row {
        case 0:
            cell.filter = F_DAIRY
            break
        case 1:
            cell.filter = F_VEG
            break
        case 2:
            cell.filter = F_NUTS
            break
        default:
            print("ERROR: Set filter table error.")
            return cell
        }
        text = filtersText[cell.filter!]!
        image = filtersImage[cell.filter!]!
        cell.textLabel?.text = "Is it \(text)"
        cell.textLabel?.backgroundColor = UIColor.clearColor() // to be able to see switch
        cell.imageView?.image = UIImage(named: image)
        return cell
    }
    
    /* tableView -> happens on senlection of row
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}
    
    // MARK: Other functions
    
    /* prepareForSegue
    - sends info to add match page
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nextPage = segue.destinationViewController as? AddIngredientAddMatchViewController {
            nextPage.firstIngredient = PFIngredient(
                name: name!,
                isDairy: filtersOn[F_DAIRY]!,
                isNuts: filtersOn[F_NUTS]!,
                isVege: filtersOn[F_VEG]!
            )
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    /* filterSwitchWasChanged
    - response to filter switch changes
    */
    func filterSwitchWasChanged(sender: UISwitch) {
        if let filterCell = sender.superview?.superview as? SetFilterTableViewCell {
            if let filter = filterCell.filter {
                filtersOn[filter] = sender.on
            }
        }
    }
    
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