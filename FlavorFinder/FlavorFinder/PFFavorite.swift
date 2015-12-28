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
    
    @NSManaged var user: PFUser
    @NSManaged var match: PFObject
    
    convenience init(user: PFUser, match: PFObject) {
        self.init()
        self.user = user
        self.match = match
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