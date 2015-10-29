//
//  Database.swift
//  FlavorFinder
//
//  Created by Sudikoff Lab iMac on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import SQLite

// Constants for schema strings.
let SCHEMA_TABLE_INGREDIENTS = "ingredients"
let SCHEMA_TABLE_MATCHES = "matches"
let SCHEMA_COL_ID = Expression<Int>("id")
let SCHEMA_COL_MATCHID = Expression<Int>("match_id")
let SCHEMA_COL_MATCHLEVEL = Expression<Int>("match_level")
let SCHEMA_COL_NAME = Expression<String>("name")

var db: Connection!
var matchesTable: Table!
var ingredientsTable: Table!
var allIngredients = [Ingredient]() // Array of all ingredients from database.

func readDatabase() {
    // Connect to database.
    let dbpath = NSBundle.mainBundle().pathForResource("flavorbible", ofType: "db")
    do {
        db = try Connection(dbpath!)
    } catch {}
    
    // Define our tables.
    ingredientsTable = Table(SCHEMA_TABLE_INGREDIENTS)
    matchesTable = Table(SCHEMA_TABLE_MATCHES);
    
    // Create all Ingredients from database.
    for ingredient in db.prepare(ingredientsTable) {
        let possible_id : Int? = ingredient[SCHEMA_COL_ID]
        let possible_name : String? = ingredient[SCHEMA_COL_NAME]
        if let id = possible_id, let name = possible_name {
            if name.isEmpty == false {
                let i = Ingredient(id: id, name: name)!
                allIngredients.append(i)
            }
        }
    }
}