//
//  PFFavorite.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 11/7/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

public class PFFavorite : PFObject, PFSubclassing {
    
    @NSManaged var user: PFUser
    @NSManaged var ingredient: PFIngredient
    
    convenience init(user: PFUser, ingredient: PFIngredient) {
        self.init()
        self.user = user
        self.ingredient = ingredient
    }
    
    override public class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static public func parseClassName() -> String {
        return "Favorite"
    }
    
    func getUser() -> PFUser {
        return user
    }
    
    func getIngredient() -> PFIngredient {
        return ingredient
    }

}