//
//  Match.swift
//  FlavorFinder
//
//  Created by Jon on 10/8/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit

class Ingredient {
    // MARK: Properties
    
    var id: Int
    var name: String
    var matchLevel = 0
    
    init?(id: Int, name: String) {
        self.id = id
        self.name = name
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
}
