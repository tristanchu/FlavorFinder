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
let _s_Favorite = "Favorite"
let _s_Vote = "Vote"
let _s_objectId = "objectId"
let _s_name = "name"
let _s_ingredientId = "ingredientId"
let _s_matchId = "matchId"
let _s_matchName = "matchName"
let _s_matchLevel = "matchLevel"
let _s_upvotes = "upvotes"
let _s_downvotes = "downvotes"
let _s_userId = "userId"
let _s_voteType = "voteType"

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
func _getMatchesForIngredient(Ingredient: PFObject) -> [PFObject] {
    let query = PFQuery(className: _s_Match)
    query.whereKey(_s_ingredientId, equalTo: Ingredient.objectId!)
    query.orderByDescending(_s_matchLevel)
    query.addAscendingOrder(_s_matchName)
    query.limit = 1000
    
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
    query.whereKey(_s_objectId, equalTo: Match[_s_matchId])
    
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
    query.whereKey(_s_ingredientId, equalTo: match[_s_matchId] as! String)
    query.whereKey(_s_matchId, equalTo: match[_s_ingredientId] as! String)
    
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
    _voteMatch(_s_upvotes, userId: userId, match: match)
    
    if let match2 = _getEquivalentMatch(match) {
        _voteMatch(_s_upvotes, userId: userId, match: match2)
    }
}

func downvoteMatch(userId: String, match: PFObject) {
    _voteMatch(_s_downvotes, userId: userId, match: match)
    
    if let match2 = _getEquivalentMatch(match) {
        _voteMatch(_s_downvotes, userId: userId, match: match2)
    }
}

func _voteMatch(voteType: String, userId: String, match: PFObject) {
    let _votes = match[voteType] as! Int
    match[voteType] = _votes + 1
    match.saveInBackground()
    
    let _vote = PFVote(voteType: voteType, userId: userId, matchId: match.objectId!)
    _vote.pinInBackground()
    _vote.saveInBackground()
}

func unvoteMatch(voteType: String, userId: String, match: PFObject) {
    _unvoteMatch(voteType, userId: userId, match: match)
    
    if let match2 = _getEquivalentMatch(match) {
        _unvoteMatch(voteType, userId: userId, match: match2)
    }
}

func _unvoteMatch(voteType: String, userId: String, match: PFObject) {
    let _votes = match[voteType] as! Int
    match[voteType] = _votes - 1
    match.saveInBackground()
    
    let query = PFQuery(className: _s_Vote)
    query.whereKey(_s_userId, equalTo: userId)
    query.whereKey(_s_matchId, equalTo: match.objectId!)
    query.fromLocalDatastore()
    
    let _vote: PFObject?
    do {
        _vote = try query.getFirstObject()
        _vote?.deleteInBackground()
    } catch {
        _vote = nil
    }
}

func hasVoted(userId: String, match: PFObject) -> PFObject? {
    let query = PFQuery(className: _s_Vote)
    query.whereKey(_s_userId, equalTo: userId)
    query.whereKey(_s_matchId, equalTo: match.objectId!)
    query.fromLocalDatastore()
    
    let _vote: PFObject?
    do {
        _vote = try query.getFirstObject()
    } catch {
        _vote = nil
    }
    
    return _vote
}

func getUserVotesFromCloud(userId: String) {
    let query = PFQuery(className: _s_Vote)
    query.whereKey(_s_userId, equalTo: userId)
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

func favoriteMatch(userId: String, ingredient: PFObject, match: PFObject) {
    let _favorite = PFFavorite(userId: userId,
                                ingredientId: ingredient.objectId!,
                                matchId: match.objectId!,
                                ingredientName: ingredient[_s_name] as! String,
                                matchName: match[_s_matchName] as! String)
    _favorite.pinInBackground()
    _favorite.saveInBackground()
}

func unfavoriteMatch(userId: String, match: PFObject) {
    let query = PFQuery(className: _s_Favorite)
    query.whereKey(_s_userId, equalTo: userId)
    query.whereKey(_s_matchId, equalTo: match.objectId!)
    query.fromLocalDatastore()
    
    let _favorite: PFObject?
    do {
        _favorite = try query.getFirstObject()
        _favorite?.deleteInBackground()
    } catch {
        _favorite = nil
    }
}

func isFavorite(userId: String, match: PFObject) -> PFObject? {
    let query = PFQuery(className: _s_Favorite)
    query.whereKey(_s_userId, equalTo: userId)
    query.whereKey(_s_matchId, equalTo: match.objectId!)
    query.fromLocalDatastore()
    
    let _favorite: PFObject?
    do {
        _favorite = try query.getFirstObject()
    } catch {
        _favorite = nil
    }
    
    return _favorite
}

func getUserFavoritesFromCloud(userId: String) {
    let query = PFQuery(className: _s_Favorite)
    query.whereKey(_s_userId, equalTo: userId)
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

func getUserFavoritesFromLocal(userId: String) -> [PFObject] {
    let query = PFQuery(className: _s_Favorite)
    query.whereKey(_s_userId, equalTo: userId)
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