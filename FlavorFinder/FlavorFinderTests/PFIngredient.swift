//
//  PFIngredient.swift
//  FlavorFinder
//
//  Created by Jon on 10/8/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

class PFIngredient : PFObject, PFSubclassing {
    
    @NSManaged var name: String
    
    convenience init(name: String) {
        self.init()
        self.name = name
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
        return "Ingredient"
    }
}
