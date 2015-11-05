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
let _s_upvotes = "upvotes"
let _s_downvotes = "downvotes"


var db: Connection!
var matchesTable: Table!
var ingredientsTable: Table!
//var allIngredients = [Ingredient]() // Array of all ingredients from database.
var _allIngredients = [PFObject]()
var _allMatches = [PFObject]()

let ingredientPinDate = "ingredientPinDate"
let matchPinDate = "matchPinDate"

// Reads local sqlite database into globals.
//func readDatabase() {
//    // Connect to database.
//    let dbpath = NSBundle.mainBundle().pathForResource("flavorbible", ofType: "db")
//    do {
//        db = try Connection(dbpath!)
//    } catch {}
//    
//    // Define our tables.
//    ingredientsTable = Table(SCHEMA_TABLE_INGREDIENTS)
//    matchesTable = Table(SCHEMA_TABLE_MATCHES)
//    
//    // Create all Ingredients from database.
//    for ingredient in db.prepare(ingredientsTable) {
//        let possible_id : Int? = ingredient[SCHEMA_COL_ID]
//        let possible_name : String? = ingredient[SCHEMA_COL_NAME]
//        if let id = possible_id, let name = possible_name {
//            if name.isEmpty == false {
//                let i = Ingredient(id: id, name: name)!
//                allIngredients.append(i)
//            }
//        }
//    }
//}

// Reads all Ingredient objects from parse database into _allIngredients.
func _readIngredients() {
    let query = PFQuery(className:_s_Ingredient)
    query.limit = 1000

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

func _getIngredientWithNameSubstring(nameSubstring: String) -> [PFObject] {
    let query = PFQuery(className:_s_Ingredient)
    query.whereKey(_s_name, containsString: nameSubstring)

    let _ingredients: [PFObject]
    do {
        _ingredients = try query.findObjects()
    } catch {
        _ingredients = []
    }
    
    return _ingredients
}

// Queries parse database for Match objects for given ingredient.
func _getMatchesForIngredient(Ingredient: PFObject) -> [PFObject] {
    let query = PFQuery(className:_s_Match)
    query.whereKey(_s_ingredientId, equalTo: Ingredient.objectId!)
    query.limit = 30
//    query.fromLocalDatastore()
    
    let _matches: [PFObject]
    do {
        _matches = try query.findObjects()
    } catch {
        _matches = []
    }
    
//    var _matches: [PFObject] = []
//    query.findObjectsInBackgroundWithBlock {
//        (matches: [PFObject]?, error: NSError?) -> Void in
//        if let error = error {
//            print(error)
//        } else {
//            _matches = matches!
//        }
//    }
    
    return _matches
}

// Gets Ingredient object for match in given Match object.
func _getIngredientForMatch(Match: PFObject) -> PFObject? {
    let query = PFQuery(className:_s_Ingredient)
    query.whereKey(_s_objectId, equalTo: Match[_s_matchId])
//    query.fromLocalDatastore()
    
    let _ingredient: PFObject?
    do {
        _ingredient = try query.getFirstObject()
    } catch {
        _ingredient = nil
    }

//    var _ingredient: PFObject?
//    query.getFirstObjectInBackgroundWithBlock {
//        (ingredient: PFObject?, error: NSError?) -> Void in
//        if error == nil && ingredient != nil {
//            _ingredient = ingredient!
//        } else {
//            print(error)
//        }
//    }
    
    return _ingredient
}

func _getMatchLevelForIngredientAndMatch(Ingredient: PFObject, Ingredient_match: PFObject) -> Int {
    
    let query = PFQuery(className:_s_Match)
    query.whereKey(_s_ingredientId, equalTo: Ingredient.objectId!)
    query.whereKey(_s_matchId, equalTo: Ingredient_match.objectId!)

    
    let _matchLevel: Int
    do {
        let _match: PFObject = try query.getFirstObject()
        _matchLevel = _match[_s_matchLevel] as! Int
    } catch {
        _matchLevel = -1
    }
    
//    var _matchLevel = -1
//    query.getFirstObjectInBackgroundWithBlock {
//        (match: PFObject?, error: NSError?) -> Void in
//        if error == nil && match != nil {
//            let _match = match!
//            _matchLevel = _match[_s_matchLevel] as! Int
//        } else {
//            print(error)
//        }
//    }

    return _matchLevel
}

func upvoteMatch(objectId1: String, objectId2: String) {
    incrementVote(_s_upvotes, objectId1: objectId1, objectId2: objectId2)
    incrementVote(_s_upvotes, objectId1: objectId2, objectId2: objectId1)
}

func downvoteMatch(objectId1: String, objectId2: String) {
    incrementVote(_s_downvotes, objectId1: objectId1, objectId2: objectId2)
    incrementVote(_s_downvotes, objectId1: objectId2, objectId2: objectId1)
}

func incrementVote(voteType: String, objectId1: String, objectId2: String) {
    let query = PFQuery(className:_s_Match)
    query.whereKey(_s_ingredientId, equalTo: objectId1)
    query.whereKey(_s_matchId, equalTo: objectId2)
    
    query.getFirstObjectInBackgroundWithBlock {
        (match: PFObject?, error: NSError?) -> Void in
        if error == nil && match != nil {
            let _match = match!
            let _votes = _match[voteType] as! Int
            _match[voteType] = _votes + 1
            _match.saveInBackground()
        } else {
            print(error)
        }
    }
}
