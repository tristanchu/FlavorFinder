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
    
    @NSManaged var userId: String
    @NSManaged var matchId: String
    @NSManaged var voteType: String
    
    init(voteType: String, userId: String, matchId: String) {
        super.init()
        self.voteType = voteType
        self.userId = userId
        self.matchId = matchId
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
