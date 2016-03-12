//
//  PFList.swift
//  FlavorFinder
//
//  Created by Jon on 1/24/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class PFList : PFObject, PFSubclassing {
    
    @NSManaged var user: PFUser
    @NSManaged var ingredients: [PFIngredient]
    @NSManaged var title: String
    
    convenience init(user: PFUser, title: String, ingredients: [PFIngredient]) {
        self.init()
        self.user = user
        self.title = title
        self.ingredients = ingredients
    }
    
    convenience init(user: PFUser, title: String) {
        self.init()
        self.user = user
        self.title = title
        self.ingredients = [PFIngredient]()
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "List"
    }
    
    func getUser() -> PFUser {
        return user
    }
    
    func getName() -> String {
        return title
    }
    
    func getList() -> [PFIngredient] {
        return ingredients
    }
    
    func addIngredient(ingredient: PFIngredient) {
        ingredients.append(ingredient)
        self.pinInBackground()
        self.saveInBackground()
    }
}