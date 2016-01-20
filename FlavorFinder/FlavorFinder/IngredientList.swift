
//
//  IngredientList.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/18/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Object represents a list of ingredients created by a user for in-app use.
//  Whether or not it will be represented like so in Parse remains to be seen...
//

import Foundation
import Parse

class IngredientList : NSObject {
    
    // not yet implemented in Parse! Need to discuss best practices for that.
    // might be individual ingredients matched to a list ID and we filter based on list ID,
    // but for ease of testing better to have a class that aggregates all of them into a unit
    // at least at the local level
    
    // needs further functionality
    
    // set arbitrarily --
    // lists should have a max particularly for display reasons! we will adjust this
    // lists definitely need to have a name but don't see why not 1 char
    let NAME_MAX_CHAR = 20
    let NAME_MIN_CHAR = 1
    
    var user: PFUser
    var name: String

    init?(user: PFUser, name: String) {
        self.user = user
        self.name = name
        super.init()
        if (!self.isValidName(self.name)) {
            return nil
        }
    }
    
    func isValidName(name: String) -> Bool {
        if (name.isEmpty ||
            name.characters.count > NAME_MAX_CHAR ||
            name.characters.count < NAME_MIN_CHAR)
        {
                return false
        } else {
            return true
        }
    }
    
    func rename(name: String) {
        if (isValidName(name)) {
            self.name = name
        }
    }
    
    func getUser() -> PFUser {
        return self.user
    }
    
    func getName() -> String {
        return self.name
    }
    
}