//
//  SearchUtils.swift
//  FlavorFinder
//
//  Util functions to use in search
//
//  Created by Courtney Ligh on 2/2/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse


// MARK: Properties: -----------------------------------------------
var currentSearch : [PFIngredient] = []
var currentResults : [(ingredient: PFIngredient, rank: Int)] = []

// Parse DB Functions: -----------------------------------------------

/* getMatchingIngredients
    Queries Parse db for match objects for given ingredient then
    returns [(PFIngredient, int)] of the matching ingredients
*/
func getMatchingIngredients(ingredient: PFIngredient) -> [(ingredient: PFIngredient, rank: Int)] {
    var results: [(ingredient: PFIngredient, rank: Int)] = []
    let matches: [PFObject] = getMatchObjectsForIngredient(ingredient)
    // TODO: change to mapping:
    for match in matches {
        let otherIngredient =
            (match[_s_secondIngredient] as! PFIngredient == ingredient)
                ? match[_s_secondIngredient] as! PFIngredient
                : match[_s_firstIngredient] as! PFIngredient
        let matchRank = match[_s_matchLevel] as! Int
        results.append((ingredient: otherIngredient, rank: matchRank))
    }

    return results
}

/* getMatchObjectsForIngredient
    Queries parse db for match objects for given ingredient.
    returns [PFObject] - match objects
*/
func getMatchObjectsForIngredient(ingredient: PFIngredient) -> [PFObject] {
    let query = PFQuery(className: _s_Match)
    // TODO: look into how matches are stored.
    query.whereKey(_s_firstIngredient, equalTo: ingredient)
    query.orderByDescending(_s_matchLevel)
    query.limit = QUERY_LIMIT
    
    let _matches: [PFObject]
    do {
        _matches = try query.findObjects()
    } catch {
        _matches = []
    }
    return _matches
}



// Search Functions: -----------------------------------------------

/* addToSearch
        current_results = [PFIngredient] existing results
        new_ingredient = PFIngredient to be added to currentSearch
    filters current results -> keeps what also matches with new ingredient
    returns new results
*/
func addToSearch(currentResults: [(ingredient: PFIngredient, rank: Int)], newIngredient: PFIngredient) -> [(ingredient: PFIngredient, rank: Int)] {
    // Create new results list to populate
    var newResults : [(ingredient: PFIngredient, rank: Int)] = []
    
    // get new ingredient matches:
    let newIngredientMatches = getMatchingIngredients(newIngredient);
    
    // check if each old result in matches for new ingredient.
    // if they are, then keep it and add ranks together.
    for oldResult in currentResults {
        // findMatchRank returns -1 if not found
        let newIngredientMatchRank = findMatchRank(newIngredientMatches, b: oldResult)
        if newIngredientMatchRank >= 0 {
            let newRank = oldResult.rank + newIngredientMatchRank
            newResults.append((ingredient: oldResult.ingredient, rank: newRank))
        }
    }
    
    return newResults
}

/* getMultiSearch
    creates results [(ingredient: PFIngredient, rank: Int)] based on the
        currentSearch [PFIngredient]
*/
func getMultiSearch(currSearch: [PFIngredient]) -> [(ingredient: PFIngredient, rank: Int)] {
    // Create new results list to populate:
    var newResults : [(ingredient: PFIngredient, rank: Int)] = []
    // if currSearch is empty (it shouldn't be) return empty
    if currSearch.count == 0 { return newResults }
    
    // get search results for first ingredient:
    newResults = getMatchingIngredients(currSearch[0])
    
    // go through rest of ingredients:
    var i: Int = 1
    while i < currSearch.count {
        newResults = addToSearch(newResults, newIngredient: currSearch[i])
        i += 1
    }
    // return ending results
    return newResults
}



// SEARCH HELPER FUNCTIONS --------------------------------------

/* sortByRank -- sorts results by rank
*/
func sortByRank(results: [(ingredient: PFIngredient, rank: Int)]) -> [(ingredient: PFIngredient, rank: Int)] {
    return results.sort {$0.1 == $1.1 ? $0.1 > $1.1 : $0.1 > $1.1 }
}


/* containsIngredient
- helper function to see if results contain an ingredient
(for multi-search)
*/
func containsIngredient(a: [(ingredient: PFIngredient, rank:Int)], b: PFIngredient) -> Bool {
    // return true if ingredient found in the first part of the tuple
    for (a1, _) in a { if a1 == b { return true}}
    return false
}

/* containsMatch
- helper function to see if results match by ingredient (ignoring rank)
returns if a contains b (or b is found in a)
*/
func containsMatch(a: [(ingredient: PFIngredient, rank: Int)], b: (ingredient: PFIngredient, rank: Int)) -> Bool {
    let (b1, _) = b
    for (a1, _) in a { if a1 == b1 {return true}}
    return false
}

/* findMatchRank
- helper function to see if can find current result (ingredient, rank) in
list of them.
looks for if a contains b (or b is found in a)
-- returns b2 rank if yes, -1 if not
*/
func findMatchRank(a: [(ingredient: PFIngredient, rank: Int)], b: (ingredient: PFIngredient, rank: Int)) -> Int {
    let (b1, b2) = b
    for (a1, _) in a { if a1 == b1 { return b2 }}
    return -1
}

