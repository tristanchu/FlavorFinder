
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
    
    var user: PFUser
    var name: String

    init?(user: PFUser, name: String) {
        self.user = user
        self.name = name
        super.init()
        if (self.name == "") {
            print("no name!!!!!!!!!!!!!")
            return nil
        }
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