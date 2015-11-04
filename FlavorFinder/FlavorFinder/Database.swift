//
//  Database.swift
//  FlavorFinder
//
//  Created by Jon on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import SQLite
import Parse

// Constants for schema strings.
let SCHEMA_TABLE_INGREDIENTS = "ingredients"
let SCHEMA_TABLE_MATCHES = "matches"
let SCHEMA_COL_ID = Expression<Int>("id")
let SCHEMA_COL_MATCHID = Expression<Int>("match_id")
let SCHEMA_COL_MATCHLEVEL = Expression<Int>("match_level")
let SCHEMA_COL_NAME = Expression<String>("name")

let _s_Ingredient = "Ingredient"
let _s_Match = "Match"
let _s_objectId = "objectId"
let _s_name = "name"
let _s_ingredientId = "ingredientId"
let _s_matchId = "matchId"
let _s_matchLevel = "matchLevel"


var db: Connection!
var matchesTable: Table!
var ingredientsTable: Table!
var allIngredients = [Ingredient]() // Array of all ingredients from database.
var _allIngredients = [PFObject]()
var _allMatches = [PFObject]()

let ingredientPinDate = "ingredientPinDate"
let matchPinDate = "matchPinDate"

// Reads local sqlite database into globals.
func readDatabase() {
    // Connect to database.
    let dbpath = NSBundle.mainBundle().pathForResource("flavorbible", ofType: "db")
    do {
        db = try Connection(dbpath!)
    } catch {}
    
    // Define our tables.
    ingredientsTable = Table(SCHEMA_TABLE_INGREDIENTS)
    matchesTable = Table(SCHEMA_TABLE_MATCHES)
    
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

// Reads all Ingredient objects from parse database into _allIngredients.
func _readIngredients() {
    let query = PFQuery(className:_s_Ingredient)
    query.limit = 3000

    query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
        if let error = error {
            // Handle error
            print(error)
        } else {
            _allIngredients = objects!
            for object in objects! {
                object.pinInBackground()
            }
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: ingredientPinDate)
        }
    }
}

//PFCloud.job("findAll", function(request, status) {
//    var result = [];
//    
//    var processCallback = function(res) {
//        result = result.concat(res);
//        if (res.length === 1000) {
//            process(res[res.length-1].id);
//            return;
//        }
//        
//        // do something about the result, result is all the object you needed.
//        status.success("final length " + result.length);
//    }
//    var process = function(skip) {
//        
//        var query = PFQuery(className:_s_Match)
//        
//        if (skip) {
//            console.log("in if");
//            query.greaterThan("objectId", skip);
//        }
//        query.limit(1000);
//        query.ascending("objectId");
//        query.find().then(function querySuccess(res) {
//            processCallback(res);
//            }, function queryFailed(reason) {
//                status.error("query unsuccessful, length of result " + result.length + ", error:" + error.code + " " + error.message);
//            });
//    }
//    process(false);
//});

func _readMatches() {

    
    let query = PFQuery(className:_s_Match)
    query.limit = 33000
    
    query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
        if let error = error {
            // Handle error
            print(error)
        } else {
            _allMatches = objects!
            for object in objects! {
                object.pinInBackground()
            }
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: matchPinDate)
        }
    }
}

// Queries parse database for Match objects for given ingredient.
func _getMatchesForIngredient(Ingredient: PFObject) -> [PFObject] {
    let query = PFQuery(className:_s_Match)
    query.whereKey(_s_ingredientId, equalTo: Ingredient.objectId!)
    query.fromLocalDatastore()
    query.limit = 3000
    
    let _matches: [PFObject]
    do {
        _matches = try query.findObjects()
    } catch {
        _matches = []
    }
    
    return _matches

//    query.findObjectsInBackgroundWithBlock {
//        (matches: [PFObject]?, error: NSError?) -> Void in
//        if let error = error {
//            print(error)
//        } else {
//            return matches!
////            _matches = matches!
//        }
//    }
//    
}

// Gets Ingredient object for match in given Match object.
func _getIngredientForMatch(Match: PFObject) -> PFObject? {
    let query = PFQuery(className:_s_Ingredient)
    query.whereKey(_s_objectId, equalTo: Match[_s_matchId])
    query.fromLocalDatastore()
    
    let _ingredient: PFObject?
    do {
        _ingredient = try query.getFirstObject()
    } catch {
        _ingredient = nil
    }

    return _ingredient

//    query.getFirstObjectInBackgroundWithBlock {
//        (ingredient: PFObject?, error: NSError?) -> Void in
//        if error == nil && ingredient != nil {
//            _ingredient = ingredient!
//        } else {
//            print(error)
//        }
//    }
}

func _getMatchLevelForIngredientAndMatch(Ingredient: PFObject, Ingredient_match: PFObject) -> Int {
    var _matchLevel = -1
    
    let query = PFQuery(className:_s_Match)
    query.whereKey(_s_ingredientId, equalTo: Ingredient.objectId!)
    query.whereKey(_s_matchId, equalTo: Ingredient_match.objectId!)

    query.getFirstObjectInBackgroundWithBlock {
        (match: PFObject?, error: NSError?) -> Void in
        if error == nil && match != nil {
            let _match = match!
            _matchLevel = _match[_s_matchLevel] as! Int
        } else {
            print(error)
        }
    }

    return _matchLevel
}
