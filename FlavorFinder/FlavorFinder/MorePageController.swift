//
//  MorePageController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse

class MorePageController: UIViewController, UITextFieldDelegate {

    override func viewDidAppear(animated: Bool) {
        if let navi = self.tabBarController?.navigationController as? MainNavigationController {
            self.tabBarController?.navigationItem.setLeftBarButtonItems([], animated: true)
            self.tabBarController?.navigationItem.setRightBarButtonItems([], animated: true)
            navi.reset_navigationBar()
            
            self.tabBarController?.navigationItem.title = ""
        }
        
        super.viewDidAppear(animated)
    }
    
    // FOR TEST PURPOSESONLY!!!
    @IBOutlet weak var morePageLabel: UILabel!
    @IBAction func loginTestUser(sender: AnyObject) {
        
        if currentUser != nil {
            
            let thing1 = PFIngredient(name: "bananas")
            let thing2 = PFIngredient(name: "applesauce")
            let ingredientsList: [PFIngredient] = [thing1, thing2]
            
            createIngredientList(currentUser!, title: "TestList", ingredients: ingredientsList)
        }
    }

}
