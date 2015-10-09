//
//  Match.swift
//  FlavorFinder
//
//  Created by Sudikoff Lab iMac on 10/8/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit

class Match {
    // MARK: Properties
    
    var name: String
    
    init?(name: String) {
        self.name = name
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
}
