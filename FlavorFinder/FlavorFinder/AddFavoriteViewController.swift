//
//  AddFavoriteViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/8/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//

import Foundation
import Parse
import UIKit

class AddFavoriteViewController: SearchIngredientsViewController {
    
    // MARK: Properties:
    let pageTitle = "Add to Favorites"
    let alreadyContainsText = " is already in your favorites"

    // MARK: connections:
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var addIngredientSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
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
        
        // Rounded edges in search bar:
        self.addIngredientSearchBar.layer.cornerRadius = ROUNDED_SIZE
        self.addIngredientSearchBar.clipsToBounds = ROUNDED_EDGES
        
        // grey background
        view.backgroundColor = BACKGROUND_COLOR
    }
    
    // MARK: Overriding parent class functions ------------------------------
    
    /* gotSelectedIngredient
    - handle selection of ingredient in search: add to favs if not already in favs
    */
    override func gotSelectedIngredient(selected: PFIngredient) {
        if currentUser != nil {
            if isFavoriteIngredient(currentUser!, ingredient: selected) != nil {
                if selected.isDataAvailable() {
                    promptLabel.text = "\(selected.name)\(alreadyContainsText)"
                }
            } else {
                if selected.isDataAvailable() {
                    promptLabel.text = "Added \(selected.name)"
                    favoriteIngredient(currentUser!, ingredient: selected)
                }
            }
        } else {
            print("ERROR: Accessing add-to-fav page without being logged in!")
        }
    }
    
}