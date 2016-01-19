//
//  Database.swift
//  FlavorFinder
//
//  Created by Jon on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import Parse

let _s_objectId = "objectId"

let _s_Ingredient = "Ingredient"
let _s_name = "name"
let _s_kosher = "kosher"
let _s_dairy = "dairy"
let _s_nuts = "nuts"
let _s_vegetarian = "vegetarian"

let _s_Match = "Match"
let _s_match = "match"
let _s_matchName = "matchName"
let _s_firstIngredient = "firstIngredient"
let _s_secondIngredient = "secondIngredient"
let _s_matchLevel = "level"
let _s_upvotes = "upvotes"
let _s_downvotes = "downvotes"

let _s_Favorite = "Favorite"

let _s_Vote = "Vote"
let _s_voteType = "voteType"

let _s_user = "user"
let _s_userId = "userId"


var _allIngredients = [PFObject]()
var _allMatches = [PFObject]()

let ingredientPinDate = "ingredientPinDate"
let matchPinDate = "matchPinDate"


// Reads all Ingredient objects from parse database into _allIngredients.
func _readIngredients() {
    
    for iteration in [0, 1, 2] {
        let query = PFQuery(className: _s_Ingredient)
        query.limit = 1000
        query.skip = 1000 * iteration
//        query.orderByAscending(_s_name)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                for object in objects! {
                    _allIngredients.append(object)
                }
            }
        }
    }

    NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: ingredientPinDate)
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
func _getMatchesForIngredient(Ingredient: PFObject, filters: [String: Bool]) -> [PFObject] {
    let query = PFQuery(className: _s_Match)
    query.whereKey(_s_firstIngredient, equalTo: Ingredient)
    query.orderByDescending(_s_matchLevel)
    query.addAscendingOrder(_s_matchName)
    query.limit = 1000
    
    let getIngredients = PFQuery (className: _s_Ingredient)
    if filters["kosher"]! {
        getIngredients.whereKey(_s_kosher, equalTo: true)
    }
    if filters["dairy"]! {
        getIngredients.whereKey(_s_dairy, equalTo: true)
    }
    if filters["nuts"]! {
        getIngredients.whereKey(_s_nuts, equalTo: true)
    }
    if filters["vegetarian"]! {
        getIngredients.whereKey(_s_vegetarian, equalTo: true)
    }
    
    query.whereKey(_s_secondIngredient, matchesQuery: getIngredients)
    
    let _matches: [PFObject]
    do {
        _matches = try query.findObjects()
    } catch {
        _matches = []
    }
    
    return _matches
}

// Gets Ingredient object for match in given Match object.
func _getIngredientForMatch(Match: PFObject) -> PFObject? {
    let query = PFQuery(className: _s_Ingredient)
    query.whereKey(_s_objectId, equalTo: Match[_s_secondIngredient])
    
    let _ingredient: PFObject?
    do {
        _ingredient = try query.getFirstObject()
    } catch {
        _ingredient = nil
    }
    
    return _ingredient
}

func _getEquivalentMatch(match: PFObject) -> PFObject? {
    let query = PFQuery(className: _s_Match)
    query.whereKey(_s_firstIngredient, equalTo: match[_s_secondIngredient] as! PFObject)
    query.whereKey(_s_secondIngredient, equalTo: match[_s_firstIngredient] as! PFObject)
    
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

func upvoteMatch(user: PFUser, match: PFObject) {
    _voteMatch(user, match: match, voteType: _s_upvotes)
    
    if let match2 = _getEquivalentMatch(match) {
        _voteMatch(user, match: match2, voteType: _s_upvotes)
    }
}

func downvoteMatch(user: PFUser, match: PFObject) {
    _voteMatch(user, match: match, voteType: _s_downvotes)
    
    if let match2 = _getEquivalentMatch(match) {
        _voteMatch(user, match: match2, voteType: _s_downvotes)
    }
}

func _voteMatch(user: PFUser, match: PFObject, voteType: String) {
    let _votes = match[voteType] as! Int
    match[voteType] = _votes + 1
    match.saveInBackground()
    
    let _vote = PFVote(user: user, match: match, voteType: voteType)
    _vote.pinInBackground()
    _vote.saveInBackground()
}

func unvoteMatch(user: PFUser, match: PFObject, voteType: String) {
    _unvoteMatch(user, match: match, voteType: voteType)
    
    if let match2 = _getEquivalentMatch(match) {
        _unvoteMatch(user, match: match2, voteType: voteType)
    }
}

func _unvoteMatch(user: PFUser, match: PFObject, voteType: String) {
    let _votes = match[voteType] as! Int
    match[voteType] = _votes - 1
    match.saveInBackground()
    
    let query = PFQuery(className: _s_Vote)
    query.whereKey(_s_user, equalTo: user)
    query.whereKey(_s_match, equalTo: match)
    query.fromLocalDatastore()
    
    let _vote: PFObject?
    do {
        _vote = try query.getFirstObject()
        _vote?.deleteInBackground()
    } catch {
        _vote = nil
    }
}

func hasVoted(user: PFUser, match: PFObject) -> PFObject? {
    let query = PFQuery(className: _s_Vote)
    query.whereKey(_s_user, equalTo: user)
    query.whereKey(_s_match, equalTo: match)
    query.fromLocalDatastore()
    
    let _vote: PFObject?
    do {
        _vote = try query.getFirstObject()
    } catch {
        _vote = nil
    }
    
    return _vote
}

func getUserVotesFromCloud(user: PFUser) {
    let query = PFQuery(className: _s_Vote)
    query.whereKey(_s_user, equalTo: user)
    query.limit = 1000
    
    query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
        if let error = error {
            print(error)
        } else {
            for object in objects! {
                object.pinInBackground()
            }
        }
    }
}

func favoriteMatch(user: PFUser, match: PFObject) {
    let _favorite = PFFavorite(user: user, match: match)
    
    _favorite.pinInBackground()
    _favorite.saveInBackground()
}

func unfavoriteMatch(user: PFUser, match: PFObject) {
    let query = PFQuery(className: _s_Favorite)
    query.whereKey(_s_user, equalTo: user)
    query.whereKey(_s_match, equalTo: match)
    query.fromLocalDatastore()
    
    let _favorite: PFObject?
    do {
        _favorite = try query.getFirstObject()
        _favorite?.deleteInBackground()
    } catch {
        _favorite = nil
    }
}

func isFavorite(user: PFUser, match: PFObject) -> PFObject? {
    let query = PFQuery(className: _s_Favorite)
    query.whereKey(_s_user, equalTo: user)
    query.whereKey(_s_match, equalTo: match)
    query.fromLocalDatastore()
    
    let _favorite: PFObject?
    do {
        _favorite = try query.getFirstObject()
    } catch {
        _favorite = nil
    }
    
    return _favorite
}

func getUserFavoritesFromCloud(user: PFUser) {
    let query = PFQuery(className: _s_Favorite)
    query.whereKey(_s_user, equalTo: user)
    query.limit = 1000
    
    query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
        if let error = error {
            print(error)
        } else {
            for object in objects! {
                object.pinInBackground()
            }
        }
    }
}

func getUserFavoritesFromLocal(user: PFUser) -> [PFObject] {
    let query = PFQuery(className: _s_Favorite)
    query.whereKey(_s_user, equalTo: user)
    query.limit = 1000
    query.fromLocalDatastore()
    
    let _favorites: [PFObject]
    do {
        _favorites = try query.findObjects()
    } catch {
        _favorites = []
    }
    
    return _favorites
}