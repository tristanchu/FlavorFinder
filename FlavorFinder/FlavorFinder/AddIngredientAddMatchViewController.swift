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
    
    // MARK: Connections:
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var chooseIngredientSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: Actions:
    
    @IBAction func submitButtonWasPressed(sender: AnyObject) {
    }
    
    // MARK: Override methods:
    
    /* viewDidLoad:
    */
    override func viewDidLoad() {
        // Assign values to parent class variables
//        ingredientSearchBar = chooseIngredientSearchBar
//        searchTable = searchTableView
        navTitle = pageTitle
        
        // Call super
        super.viewDidLoad()
    }
    
}