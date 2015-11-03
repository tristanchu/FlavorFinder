//
//  Match.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 11/3/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

class Match {
    // model compatible with more than just pairs
    // (if need be for future growth)
    
    // MARK: Properties
    
    var matchId: Int
    var ingredientIds: [Int]
    var names: [String]
    lazy var description: String = { return "" }()
    
    init?(matchId: Int, ingredientIds: [Int], names: [String]) {
        self.matchId = matchId
        self.ingredientIds = ingredientIds
        self.names = names
        
        // initiation can fail
        if ingredientIds.isEmpty || names.isEmpty || ingredientIds.count != names.count || names.count < 2 {
            return nil
        }
        
        // generate string representation
        for i in 0..<self.names.count {
            description += self.names[i]
            if i + 1 != self.names.count {
                description += " + "
            }
        }
    }
        
}