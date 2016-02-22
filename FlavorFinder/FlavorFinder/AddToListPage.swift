//
//  AddToListPage.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/21/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class AddToListPage: SearchIngredientsViewController, UITextFieldDelegate {
    
    // MARK: Properties:
    var ingredientList = [PFIngredient]()
    var listObject: PFObject!
    var listTitle = ""
    
    var cancelBtn: UIBarButtonItem = UIBarButtonItem()
    let cancelBtnAction = "cancelBtnClicked:"
    let cancelBtnString = String.fontAwesomeIconWithName(.ChevronLeft) + " Cancel"
    
    
    // Visual:
    let pageTitle = "Add Ingredient To List"
    
    // MARK: Override methods: ------------
    /* viewDidLoad:
    Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Visuals:
        setUpCancelButton()
    }
    
    /* viewDidAppear:
    Setup when user goes into page.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // Get navigation bar on top:
        if let navi = self.tabBarController?.navigationController
            as? MainNavigationController {
                self.tabBarController?.navigationItem.setLeftBarButtonItems(
                    [self.cancelBtn], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                navi.reset_navigationBar()
                self.tabBarController?.navigationItem.title = pageTitle
                self.cancelBtn.enabled = true
                print("here")
        }
        print("hello")
        
    }
    
    
    // MARK: Back Button Functions -------------------------------------
    
    /* setUpBackButton
    sets up the back button visuals for navigation
    */
    func setUpCancelButton() {
        cancelBtn.setTitleTextAttributes(attributes, forState: .Normal)
        cancelBtn.title = self.backBtnString
        cancelBtn.tintColor = NAVI_BUTTON_COLOR
        cancelBtn.target = self
        cancelBtn.action = "cancelBtnClicked"  // refers to: backBtnClicked()
    }
    
    /* backBtnClicked
    - action for back button
    */
    func cancelBtnClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}
