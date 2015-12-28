//
//  PFMatch.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 11/3/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

class PFMatch : PFObject, PFSubclassing {
    
    @NSManaged var firstIngredient: PFObject
    @NSManaged var secondIngredient: PFObject
    @NSManaged var matchName: String
    @NSManaged var upvotes: Int
    @NSManaged var downvotes: Int
    
    convenience init(firstIngredient: PFObject, secondIngredient: PFObject) {
        self.init()
        self.firstIngredient = firstIngredient
        self.secondIngredient = secondIngredient
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
        return "Match"
    }
    
}