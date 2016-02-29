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
var currentResults : [(ingredient: PFIngredient, rank: Double)] = []
var currentIngredientToAdd : [PFIngredient] = []

// Search Term Parsing Functions: ------------------------------------

/* getPossibleIngredients
- returns list of possible ingredients with partial name matching to string
*/
func getPossibleIngredients(searchText: String) -> [PFIngredient] {
    if let allIngredients = _allIngredients as? [PFIngredient] {
        let filteredResults = allIngredients.filter({ (ingredient) -> Bool in
            let tmp: PFObject = ingredient
            let range = tmp[_s_name].rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        return filteredResults
    } else {
        return [PFIngredient]()
    }
}

// Parse DB Functions: -----------------------------------------------

/* getMatchingIngredients
    Queries Parse db for match objects for given ingredient then
    returns [(PFIngredient, Double)] of the matching ingredients
*/
func getMatchingIngredients(ingredient: PFIngredient) -> [(ingredient: PFIngredient, rank: Double)] {
    var results: [(ingredient: PFIngredient, rank: Double)] = []
    let matches: [PFObject] = getMatchObjectsForIngredient(ingredient)
    // TODO: change to mapping:
    for match in matches {
        let otherIngredient =
            (match[_s_secondIngredient] as! PFIngredient == ingredient)
                ? match[_s_firstIngredient] as! PFIngredient
                : match[_s_secondIngredient] as! PFIngredient
        let matchRank = match[_s_matchLevel] as? Int
        let upvotes = match[_s_upvotes] as! Int
        let downvotes = match[_s_downvotes] as! Int
        // TODO: transition off of matchLevel, or find better conversion to votes (magic # now)
        var ups = upvotes
        if let _ = matchRank {
            ups += matchRank! * 30
        }
        let downs = downvotes
        let confidenceRank = confidence(ups, downs: downs)
        results.append((ingredient: otherIngredient, rank: confidenceRank))
    }

    return results
}

/* getMatchObjectsForIngredient
    Queries parse db for match objects for given ingredient.
    returns [PFObject] - match objects
*/
func getMatchObjectsForIngredient(ingredient: PFIngredient) -> [PFObject] {
    let query = PFQuery(className: _s_Match)
    query.whereKey(_s_firstIngredient, equalTo: ingredient)
    query.includeKey(_s_name)
    query.limit = QUERY_LIMIT
    
    var _matches: [PFObject]
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
func addToSearch(currentResults: [(ingredient: PFIngredient, rank: Double)], newIngredient: PFIngredient) -> [(ingredient: PFIngredient, rank: Double)] {
    // Create new results list to populate
    var newResults : [(ingredient: PFIngredient, rank: Double)] = []
    
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
    creates results [(ingredient: PFIngredient, rank: Double)] based on the
        currentSearch [PFIngredient]
*/
func getMultiSearch(currSearch: [PFIngredient]) -> [(ingredient: PFIngredient, rank: Double)] {
    // Create new results list to populate:
    var newResults : [(ingredient: PFIngredient, rank: Double)] = []
    // if currSearch is empty (it shouldn't be) return empty
    if currSearch.isEmpty { return newResults }
    
    // get search results for first ingredient:
    newResults = getMatchingIngredients(currSearch[0])
    
    // go through rest of ingredients:
    for i in 1..<currSearch.count {
        newResults = addToSearch(newResults, newIngredient: currSearch[i])
    }
    // return ending results
    return newResults
}



// SEARCH HELPER FUNCTIONS --------------------------------------

/* sortByRank -- sorts results by rank
*/
func sortByRank(results: [(ingredient: PFIngredient, rank: Double)]) -> [(ingredient: PFIngredient, rank: Double)] {
    return results.sort {$0.1 == $1.1 ? $0.1 > $1.1 : $0.1 > $1.1 }
}

/* containsIngredient
- helper function to see if results contain an ingredient
(for multi-search)
*/
func containsIngredient(a: [(ingredient: PFIngredient, rank: Double)], b: PFIngredient) -> Bool {
    // return true if ingredient found in the first part of the tuple
    for (a1, _) in a { if a1 == b { return true}}
    return false
}

/* containsMatch
- helper function to see if results match by ingredient (ignoring rank)
returns if a contains b (or b is found in a)
*/
func containsMatch(a: [(ingredient: PFIngredient, rank: Double)], b: (ingredient: PFIngredient, rank: Double)) -> Bool {
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
func findMatchRank(a: [(ingredient: PFIngredient, rank: Double)], b: (ingredient: PFIngredient, rank: Double)) -> Double {
    let (b1, _) = b
    for (a1, a2) in a { if a1 == b1 { return a2 }}
    return -1
}

