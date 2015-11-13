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
    @NSManaged var matchId: String

    init(uesrId: String, matchId: String) {
        super.init()
        self.userId = userId
        self.matchId = matchId
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