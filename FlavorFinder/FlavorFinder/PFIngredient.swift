//
//  PFIngredient.swift
//  FlavorFinder
//
//  Created by Jon on 10/8/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

public class PFIngredient : PFObject, PFSubclassing {
    
    @NSManaged var name: String
    @NSManaged var isDairy: Bool
    @NSManaged var isNuts: Bool
    @NSManaged var isVege: Bool
    
    convenience init(name: String, isDairy: Bool, isNuts: Bool, isVege: Bool) {
        self.init()
        self.name = name
        self.isDairy = isDairy
        self.isNuts = isNuts
        self.isVege = isVege
    }
    
    override public class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    public static func parseClassName() -> String {
        return "Ingredient"
    }
}
