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
    @NSManaged var ingredients: [PFObject]
    
    convenience init(user: PFUser) {
        self.init()
        self.user = user
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
}
