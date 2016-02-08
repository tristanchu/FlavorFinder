//
//  EditListPage.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/7/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class EditListPage: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties:
    var ingredientList = [PFIngredient]()
    var listObject: PFObject!
    var listTitle = ""
    
    // Parse related:
    let listClassName = "List"
    let ingredientsColumnName = "ingredients"
    let userColumnName = "user"
    let ListTitleColumnName = "title"

    // Visual related:
    let pageTitle = "Edit List"
    
    // Navigation:
    var backBtn: UIBarButtonItem = UIBarButtonItem()
    let backBtnAction = "backBtnClicked:"
    let backBtnString = String.fontAwesomeIconWithName(.ChevronLeft) + " Back"
    
    // MARK: connections:
    @IBOutlet weak var listNamePromptLabel: UILabel!
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var newNamePromptLabel: UILabel!
    
    @IBOutlet weak var newNameTextField: UITextField!
    
    @IBAction func submitAction(sender: AnyObject) {
        if newNameTextField.text != nil {
            listObject.setObject(newNameTextField.text!, forKey: ListTitleColumnName)
            listTitleLabel.text = newNameTextField.text
            listObject.saveInBackground()
        }
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        newNameTextField.text = ""
    }
    
    
    // MARK: Override methods: ----------------------------------------------
    
    
    /* viewDidLoad:
    Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title label to list title:
        listTitleLabel.text = listTitle

        // set up text field 
        newNameTextField.delegate = self
        newNameTextField.setTextLeftPadding(5)

        // Navigation buttons:
        setUpBackButton()
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
                    [self.backBtn], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                navi.reset_navigationBar()
                self.tabBarController?.navigationItem.title = "\(self.pageTitle)"
                self.backBtn.enabled = true
        }
    }
    
    // MARK: Back Button Functions -----------------------------------------
    
    
    /* setUpBackButton
    sets up the back button visuals for navigation
    */
    func setUpBackButton() {
        backBtn.setTitleTextAttributes(attributes, forState: .Normal)
        backBtn.title = self.backBtnString
        backBtn.tintColor = NAVI_BUTTON_COLOR
        backBtn.target = self
        backBtn.action = "backBtnClicked"  // refers to: backBtnClicked()
    }
    
    /* backBtnClicked
    - action for back button
    */
    func backBtnClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
}