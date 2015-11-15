//
//  PFFavorite.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 11/7/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

class PFFavorite : PFObject, PFSubclassing {
    
    @NSManaged var userId: String
    @NSManaged var ingredientId: String
    @NSManaged var matchId: String
    @NSManaged var ingredientName: String
    @NSManaged var matchName: String
    
    convenience init(userId: String, ingredientId: String, matchId: String, ingredientName: String, matchName: String) {
        self.init()
        self.userId = userId
        self.ingredientId = ingredientId
        self.matchId = matchId
        self.ingredientName = ingredientName
        self.matchName = matchName
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Favorite"
    }

}