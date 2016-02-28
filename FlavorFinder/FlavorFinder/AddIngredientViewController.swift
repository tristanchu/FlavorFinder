//
//  AddIngredientViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/28/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit

class AddIngredientViewController : GotNaviViewController {
    
    // MARK: Properties
    let pageTitle = "Add New Ingredient"
    
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
        let name = sender.text
        sender.textColor = UIColor.blueColor() // should be standardized
        sender.textAlignment = NSTextAlignment.Center
        sender.enabled = false
        warningLabel.text = name
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
    func reset() {}
    
}