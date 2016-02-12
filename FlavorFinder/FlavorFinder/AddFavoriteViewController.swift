//
//  AddFavoriteViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/8/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Eventually, when we look to having add ingredient / add match capabilities,
//  we may want to abstract out some of this for a superclass since visually
//  these pages might be similar.
//

import Foundation
import Parse
import UIKit

class AddFavoriteViewController: SearchIngredientsViewController {
    
    // MARK: Properties:
    let pageTitle = "Add to Favorites"
    
    // MARK: connections:

    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var addIngredientSearchBar: UISearchBar!
    
    let searchTableView = UITableView() // just for dev, not permanently!
    
    // MARK: Override methods: ----------------------------------------------
    
    /* viewDidLoad:
    */
    override func viewDidLoad() {
        // Assign values to parent class variables
        ingredientSearchBar = addIngredientSearchBar
        searchTable = searchTableView
        navTitle = pageTitle
        
        // Call super
        super.viewDidLoad()
    }
    
    /* viewDidAppear:
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Overriding parent class functions ------------------------------
    
    /* gotSelectedIngredient
    - handle selection of ingredient in search: add to favs if not already in favs
    */
    override func gotSelectedIngredient(selected: PFIngredient) {
//        var favList = listObject.objectForKey(ingredientsColumnName) as! [PFIngredient]
//        if favList.contains(selected) && selected.isDataAvailable() {
//            addIngredientPromptLabel.text = "\(selected.name)\(alreadyContains)"
//        } else {
//            userList.append(selected)
//            listObject.setObject(userList, forKey: ingredientsColumnName)
//            listObject.saveInBackground()
//            if selected.isDataAvailable() {
//                addIngredientPromptLabel.text = "Added \(selected.name)"
//            }
//        }
    }
    
}