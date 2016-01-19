
//
//  IngredientList.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/18/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import Parse

class IngredientList : NSObject {
    
    // not yet implemented in Parse! Need to discuss best practices for that.
    // might be individual ingredients matched to a list ID and we filter based on list ID,
    // but for ease of testing better to have a class that aggregates all of them into a unit
    // at least at the local level
    
    // needs further functionality
    
    @NSManaged var user: PFUser
    @NSManaged var name: String

    convenience init(user: PFUser, name: String) {
        self.init()
        self.user = user
        self.name = name
    }
    
    func rename(name: String) {
        self.name = name
    }
    
    func getUser() -> PFUser {
        return self.user
    }
    
    func getName() -> String {
        return self.name
    }
    
}