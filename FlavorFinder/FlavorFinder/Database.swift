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


let _s_Ingredient = "Ingredient"
let _s_Match = "Match"
let _s_objectId = "objectId"
let _s_name = "name"
let _s_ingredientId = "ingredientId"
let _s_matchId = "matchId"
let _s_matchName = "matchName"
let _s_matchLevel = "matchLevel"
let _s_upvotes = "upvotes"
let _s_downvotes = "downvotes"

var _allIngredients = [PFObject]()
var _allMatches = [PFObject]()

let ingredientPinDate = "ingredientPinDate"
let matchPinDate = "matchPinDate"


// Reads all Ingredient objects from parse database into _allIngredients.
func _readIngredients() {
    let query = PFQuery(className: _s_Ingredient)
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
    let query = PFQuery(className: _s_Ingredient)
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
    let query = PFQuery(className: _s_Match)
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
    let query = PFQuery(className: _s_Ingredient)
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

func _getMatchObjectIdForIngredientIdAndMatchId(ingredientId: String, matchId: String) -> PFObject? {
    let query = PFQuery(className: _s_Match)
    query.whereKey(_s_ingredientId, equalTo: ingredientId)
    query.whereKey(_s_matchId, equalTo: matchId)
    
    var _match: PFObject? = nil
    
    query.getFirstObjectInBackgroundWithBlock {
        (match: PFObject?, error: NSError?) -> Void in
        if error == nil && match != nil {
            _match = match!
        } else {
            print(error)
        }
    }
    
    return _match
}

func upvoteMatch(userId: String, match: PFObject) {
    incrementVote(_s_upvotes, userId: userId, match: match)
    
    if let match2 = _getMatchObjectIdForIngredientIdAndMatchId(match[_s_matchId] as! String, matchId: match[_s_ingredientId] as! String) {
        incrementVote(_s_upvotes, userId: userId, match: match2)
    }
}

func downvoteMatch(userId: String, match: PFObject) {
    incrementVote(_s_downvotes, userId: userId, match: match)
    
    if let match2 = _getMatchObjectIdForIngredientIdAndMatchId(match[_s_matchId] as! String, matchId: match[_s_ingredientId] as! String) {
        incrementVote(_s_downvotes, userId: userId, match: match2)
    }
}

func incrementVote(voteType: String, userId: String, match: PFObject) {
    let _votes = match[voteType] as! Int
    match[voteType] = _votes + 1
    match.saveInBackground()
    
    let _vote = PFVote(voteType: voteType, userId: userId, matchId: match.objectId!)
    _vote.saveInBackground()
}
