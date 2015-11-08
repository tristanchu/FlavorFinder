#!/usr/bin/env python3
"""
Scraper for the 'The Flavor Bible'.

Created by Jon.
"""

import json
import os
import re
import sqlite3
import sys

import ebooklib
from ebooklib import epub
from bs4 import BeautifulSoup


latest_id = 0


def createTables(c):
    c.execute('''CREATE TABLE ingredients(
                id int PRIMARY KEY,
                name text UNIQUE, 
                season text,
                taste text,
                weight text,
                volume text,
                vegetarian int,
                dairy int,
                kosher int,
                nuts int
              )''')

    c.execute('''CREATE TABLE matches(
                id int,
                matchId int,
                matchLevel int,
                upvotes int,
                downvotes int,
                affinity text,
                quote text,
                PRIMARY KEY(id, matchId)
              )''')

def fixName(s):
    s = s.lower()
    if ' and ' in s:
        index = s.find(' and ')
        s = s[:index]

    if ' —' in s:
        index = s.find(' —')
        s = s[:index]
    
    if ', esp.' in s:
        index = s.find(', esp.')
        s = s[:index]

    if ', (' in s:
        index = s.find(', (')
        s = s[:index]
    elif ' (' in s:
        index = s.find(' (')
        s = s[:index]

    if ', e.g.' in s:
        index = s.find(', e.g.')
        s = s[:index]
    elif ' (e.g.' in s:
        index = s.find(' (e.g.')
        s = s[:index]

    if bool(re.search('\(.*\)', s)):
        s = re.sub(r'\s?\(.*\)', '', s)

    if s.count(',') == 1 and s.count(':') == 0:
        index = s.find(',')
        s = s[index+2:]+' '+s[:index]

    return s

def containsBlacklistedString(s):
    blacklistedStrings = [':', ' and ', ' or ', '/' ]
    
    if any(str in s for str in blacklistedStrings):
        return True
    elif s.count(','):
        return True
    elif not s.strip():
        return True
    else:
        return False

def hasBlacklistedClass(sibling):
    blacklistedClasses = ['ul3', 'p1', 'ca', 'ca3', 'ep', 'eps', 'h3', 'img', 'boxh', 'ext', 'exts', 'ext4',
                          'bl', 'bl1', 'bl3', 'sbh', 'sbtx', 'sbtx1', 'sbtx3', 'sbtx4', 'sbtx11', 'sbtx31']
    
    if any(c == sibling['class'] for c in blacklistedClasses):
        return True
    else:
        return False

def addMatches(ingredients, matches, ingredient_ids, id, i, s, match_level):
    global latest_id
    
    s = fixName(s)
    
    if s in ingredient_ids:
        match_id = ingredient_ids[s]
    else:
        match_id = latest_id
        ingredients[match_id] = {
            'tmpId': match_id,
            'name': s.lower(),
            'season': '',
            'taste': '',
            'weight': '',
            'volume': '',
            'vegetarian': 1,
            'dairy': 0,
            'kosher': 0,
            'nuts': 0
        }
        ingredient_ids[s] = match_id
        latest_id += 1

    match1 = str(id) + '_' + str(match_id)
    match2 = str(match_id) + '_' + str(id)

    if not match1 in matches:
        matches[match1] = {
            'ingredientId': id,
            'matchId': match_id,
            'matchName': '',
            'matchLevel': match_level,
            'upvotes': 0,
            'downvotes': 0,
            'affinity': '',
            'quote': ''
        }
    if not match2 in matches:
        matches[match2] = {
            'ingredientId': match_id,
            'matchId': id,
            'matchName': '',
            'matchLevel': match_level,
            'upvotes': 0,
            'downvotes': 0,
            'affinity': '',
            'quote': ''
        }


def removeExistingFiles(files):
    for f in files:
        if os.path.isfile(f):
            os.remove(f)

def writeResultsToJSON(filename, data):
    results = {}
    results['results'] = []
    for key in data:
        row = data[key]
        results['results'].append(row)
    with open(filename, 'w') as jsonfile:
        json.dump(results, jsonfile, indent=4)

def writeUpdatesToJSON(filename, data):
    results = {}
    results['results'] = []
    for item in data:
        results['results'].append(item)
    with open(filename, 'w') as jsonfile:
        json.dump(results, jsonfile, indent=4)

def loadResultsFromJSON(filename):
    with open(filename) as file:
        results = json.load(file)
        return results['results']

def writeIngredientsToTable(c, data):
    for key in data:
        row = data[key]
        c.execute("INSERT INTO ingredients VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')" % (row['tmpId'], row['name'], row['season'], row['taste'], row['weight'], row['volume'], row['vegetarian'], row['dairy'], row['kosher'], row['nuts']))

def writeMatchesToTable(c, data):
    for key in data:
        row = data[key]
        c.execute("INSERT INTO matches VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s')" % (row['ingredientId'], row['matchId'], row['matchLevel'], row['upvotes'], row['downvotes'], row['affinity'], row['quote']))

def updateMatchesToUseParseData(matches, parseIngredients):
    for match in matches:
        i_ingredient = next( (i for i in parseIngredients if i['tmpId'] == match['ingredientId']) )
        m_ingredient = next( (i for i in parseIngredients if i['tmpId'] == match['matchId']) )
        match['ingredientId'] = i_ingredient['objectId']
        match['matchId'] = m_ingredient['objectId']
        match['matchName'] = m_ingredient['name']


if __name__ == '__main__':
    
    if len(sys.argv) > 1 and sys.argv[1] == 'update':
        parseIngredients = loadResultsFromJSON('Ingredient.json')
        matches = loadResultsFromJSON('Match_tmp.json')
        updateMatchesToUseParseData(matches, parseIngredients)
        writeUpdatesToJSON('Match.json', matches)
    else:
        global latest_id

        ingredients = {}
        matches = {}
        ingredient_ids = {}
        
        ingredients_fieldnames = ['tmpId', 'name', 'season', 'taste', 'weight', 'volume', 'vegetarian', 'dairy', 'kosher', 'nuts']
        matches_fieldnames = ['ingredientId', 'matchId', 'matchLevel', 'upvotes', 'downvotes', 'affinity', 'quote']

        removeExistingFiles(['flavorbible.db', 'Ingredient_tmp.json', 'Match_tmp.json'])
        conn = sqlite3.connect('flavorbible.db')
        c = conn.cursor()
        createTables(c)
        
        book = epub.read_epub('flavorbible.epub')
        result = ''
        for item in book.get_items():
            type = item.get_type()
            if type == ebooklib.ITEM_DOCUMENT:
                soup = BeautifulSoup(item.content, 'lxml')
        
                # Find ingredient listings.
                for ingredient in soup.find_all('p', {'class' : ['lh', 'lh1']}):
                    print('HEADING: ', ingredient)

                    i = fixName(ingredient.text)
                    if containsBlacklistedString(i):
                        continue
                    
                    if i in ingredient_ids:
                        id = ingredient_ids[i]
                    else:
                        id = latest_id
                        ingredients[id] = {
                            'tmpId': id,
                            'name': i,
                            'season': '',
                            'taste': '',
                            'weight': '',
                            'volume': '',
                            'vegetarian':  1,
                            'dairy': 0,
                            'kosher': 0,
                            'nuts': 0
                        }
                        ingredient_ids[i] = id
                        latest_id += 1
                
                
                    # Find what goes well with these ingredients.
                    sibling = ingredient.find_next_sibling()
                
                    while sibling != None:
                        s = sibling.text
                        try:
                            if sibling['class'] in (['lh'], ['lh1']):
                                break
                        except:
                            break
                        print('content: ', sibling)
                        
                        # season, taste, weight, volume
                        if s.startswith('Season:'):
                            ingredients[id]['season'] = s[8:]
                        elif s.startswith('Taste:'):
                            ingredients[id]['taste'] = s[7:]
                        elif s.startswith('Weight:'):
                            ingredients[id]['weight'] = s[8:]
                        elif s.startswith('Volume:'):
                            ingredients[id]['volume'] = s[8:]
                        elif s.startswith('Tips:'):
                            sibling = sibling.find_next_sibling()
                            continue
                        elif s.startswith('Techniques:'):
                            sibling = sibling.find_next_sibling()
                            continue
                        
                        elif hasBlacklistedClass(sibling):
                            sibling = sibling.find_next_sibling()
                            continue
                        
                        # flavor affinities
                        elif sibling['class'] == ['h4']:
                            sibling = sibling.find_next_sibling()
                            while sibling != None:
                                try:
                                    if sibling.find_next_sibling()['class'] in (['lh'], ['lh1'], ['p1']):
                                        break
                                except:
                                    break
                                sibling = sibling.find_next_sibling()
                
                
                            sibling = sibling.find_next_sibling()
                            continue
            
                        elif containsBlacklistedString(fixName(s)):
                            sibling = sibling.find_next_sibling()
                            continue
                        
                        if sibling['class'] == ['ul'] or sibling['class'] == ['ul1']:
                            if sibling.find('strong') == None:
                                # match-low
                                addMatches(ingredients, matches, ingredient_ids, id, i, s, 1)
                            elif s.islower():
                                # match-medium
                                addMatches(ingredients, matches, ingredient_ids, id, i, s, 2)
                            elif s.isupper() and s.startswith('*') == False:
                                # match-high
                                addMatches(ingredients, matches, ingredient_ids, id, i, s, 3)
                            elif s.isupper() and s.startswith('*') == True:
                                # match-holy
                                addMatches(ingredients, matches, ingredient_ids, id, i, s[1:], 4)
                
                        sibling = sibling.find_next_sibling()
        
        
                    print('')

        writeResultsToJSON('Ingredient_tmp.json', ingredients)
        writeResultsToJSON('Match_tmp.json', matches)

        writeIngredientsToTable(c, ingredients)
        writeMatchesToTable(c, matches)
        
        conn.commit()
        conn.close()
