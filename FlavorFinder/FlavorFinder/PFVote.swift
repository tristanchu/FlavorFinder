//
//  PFVote.swift
//  FlavorFinder
//
//  Created by Jon on 11/5/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation

import UIKit
import Parse

class PFVote : PFObject, PFSubclassing {
    
    @NSManaged var user: PFUser
    @NSManaged var match: PFObject
    @NSManaged var voteType: String
    
    convenience init(user: PFUser, match: PFObject, voteType: String) {
        self.init()
        self.user = user
        self.match = match
        self.voteType = voteType
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
        return "Vote"
    }
    
}
