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
        
        print("all ingredients: 20 \((_allIngredients[25] as! PFIngredient).name) \((_allIngredients[26] as! PFIngredient).name) \((_allIngredients[27] as! PFIngredient).name) \((_allIngredients[28] as! PFIngredient).name) \((_allIngredients[29] as! PFIngredient).name)  24 \((_allIngredients[30] as! PFIngredient).name)")
        
        let testIngredient = _allIngredients[21] as! PFIngredient
        
        let matches = getMatchingIngredients(testIngredient)
        
        print("Testing: \(testIngredient.name)")
        
        if matches.count != 0 {
            print("have matches \(matches.count)")
            print("second one is \(matches[1].ingredient.name)")
            

            
            // test addToSearch:
//            let newMatches = addToSearch(matches, newIngredient: matches[1].ingredient)
//            if newMatches.count != 0 {
//                print("addToSearch: have matches \(newMatches.count)")
//                print("first one is \(newMatches[0].ingredient.name)")
//            } else {
//                print("No Common Matches for new matches")
//            }
            
            // test getMultiSearch
            let searchQ = [testIngredient, matches[1].ingredient]
            let multisearch = getMultiSearch(searchQ)
            if multisearch.count != 0 {
                print("multisearch: matches: \(multisearch.count)")
                print("first is: \(multisearch[0].ingredient.name)")
            } else {
                print("NO MULTISEARCH")
            }
        } else {
            print("IS EMPTY")
        }
    }

}
