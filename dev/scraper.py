#!/usr/bin/env python3
"""
Scraper for the 'The Flavor Bible'.

Created by Jon.
"""

import sqlite3
import re
import json
import os

import ebooklib
from ebooklib import epub
from bs4 import BeautifulSoup


if os.path.isfile("flavorbible.db"):
    os.remove("flavorbible.db")
if os.path.isfile("ingredients.json"):
    os.remove("ingredients.json")
if os.path.isfile("matches.json"):
    os.remove("matches.json")

conn = sqlite3.connect('flavorbible.db')
c = conn.cursor()

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
            match_id int,
            match_level int,
            upvotes int,
            downvotes int,
            affinity text,
            quote text,
            PRIMARY KEY(id, match_id)
          )''')


latest_id = 0

def fixName(s):
    s = s.lower()
    if " —" in s:
        index = s.find(" —")
        s = s[:index]
    if ", esp." in s:
        index = s.find(", esp.")
        s = s[:index]
    elif ", (" in s:
        index = s.find(", (")
        s = s[:index]
    elif ", e.g." in s:
        index = s.find(", e.g.")
        s = s[:index]
    elif " (e.g." in s:
        index = s.find(" (e.g.")
        s = s[:index]
    elif bool(re.search('\(.*\)', s)):
        s = re.sub(r'\s?\(.*\)', '', s)

    if s.count(',') == 1 and s.count(':') == 0:
        index = s.find(',')
        s = s[index+2:]+" "+s[:index]

    return s

def addMatches(ingredients, matches, ingredient_ids, id, i, s, match_level):
    global latest_id
    
    s = fixName(s)
    
    if s in ingredient_ids:
        match_id = ingredient_ids[s]
    else:
        match_id = latest_id
        ingredients[match_id] = {
            "tmp_id": match_id,
            "name": s.lower(),
            "season": '',
            "taste": '',
            "weight": '',
            "volume": '',
            "vegetarian": 1,
            "dairy": 0,
            "kosher": 0,
            "nuts": 0
        }
        ingredient_ids[s] = match_id
        latest_id += 1

    match1 = str(id) + '_' + str(match_id)
    match2 = str(match_id) + '_' + str(id)

    if not match1 in matches:
        matches[match1] = {
            "ingredient_id": id,
            "match_id": match_id,
            "match_level": match_level,
            "upvotes": 0,
            "downvotes": 0,
            "affinity": '',
            "quote": ''
        }
    if not match2 in matches:
        matches[match2] = {
            "ingredient_id": match_id,
            "match_id": id,
            "match_level": match_level,
            "upvotes": 0,
            "downvotes": 0,
            "affinity": '',
            "quote": ''
        }


def writeResultsToJSON(filename, data):
    results = {}
    results["results"] = []
    for key in data:
        row = data[key]
        results["results"].append(row)
    with open(filename, 'w') as jsonfile:
        json.dump(results, jsonfile, indent=4)


def writeIngredientsToTable(data):
    for key in data:
        row = data[key]
        c.execute("INSERT INTO ingredients VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')" % (row["tmp_id"], row["name"], row["season"], row["taste"], row["weight"], row["volume"], row["vegetarian"], row["dairy"], row["kosher"], row["nuts"]))

def writeMatchesToTable(data):
    for key in data:
        row = data[key]
        c.execute("INSERT INTO matches VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s')" % (row["ingredient_id"], row["match_id"], row["match_level"], row["upvotes"], row["downvotes"], row["affinity"], row["quote"]))



if __name__ == '__main__':
    global latest_id
    ingredients_fieldnames = ['tmp_id', 'name', 'season', 'taste', 'weight', 'volume', 'vegetarian', 'dairy', 'kosher', 'nuts']
    matches_fieldnames = ['ingredient_id', 'match_id', 'match_level', 'upvotes', 'downvotes', 'affinity', 'quote']

    ingredients = {}
    matches = {}
    
    ingredient_ids = {}

    book = epub.read_epub('flavorbible.epub')
    result = ""
    for item in book.get_items():
        type = item.get_type()
        if type == ebooklib.ITEM_DOCUMENT:
            soup = BeautifulSoup(item.content, 'lxml')
    
            # Find ingredient listings.
            for ingredient in soup.find_all('p', {'class' : ['lh', 'lh1']}):
                print('HEADING: ', ingredient)

                i = fixName(ingredient.text)
            
                if i in ingredient_ids:
                    id = ingredient_ids[i]
                else:
                    id = latest_id
                    ingredients[id] = {
                        "tmp_id": id,
                        "name": i,
                        "season": '',
                        "taste": '',
                        "weight": '',
                        "volume": '',
                        "vegetarian":  '1',
                        "dairy": '0',
                        "kosher": '0',
                        "nuts": '0'
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
                        ingredients[id]["season"] = s[8:]
                    elif s.startswith('Taste:'):
                        ingredients[id]["taste"] = s[7:]
                    elif s.startswith('Weight:'):
                        ingredients[id]["weight"] = s[8:]
                    elif s.startswith('Volume:'):
                        ingredients[id]["volume"] = s[8:]
                    elif s.startswith('Tips'):
                        sibling = sibling.find_next_sibling()
                        continue
                    elif sibling['class'] == ['ul3']:
                        sibling = sibling.find_next_sibling()
                        continue
            
                    # quote
                    elif sibling['class'] == ['p1']:
                        sibling = sibling.find_next_sibling()
                        continue
#                        quote = s
#                        sibling = sibling.find_next_sibling()
#                        s = sibling.text
#                        quote += ' ' + s
                        #c.execute("INSERT INTO matches VALUES ('%s', '', '', '', '%s')" % (i, quote))
                    elif sibling['class'] == ['ca'] or sibling['class'] == ['ca3']:
                        sibling = sibling.find_next_sibling()
                        continue
                    elif sibling['class'] == ['img']:
                        sibling = sibling.find_next_sibling()
                        continue
                    elif sibling['class'] == ['boxh']:
                        sibling = sibling.find_next_sibling()
                        continue
                    elif sibling['class'] == ['ext']:
                        sibling = sibling.find_next_sibling()
                        continue
                    elif sibling['class'] == ['exts']:
                        sibling = sibling.find_next_sibling()
                        continue
                    elif sibling['class'] == ['bl'] or sibling['class'] == ['bl1'] or sibling['class'] == ['bl3']:
                        sibling = sibling.find_next_sibling()
                        continue
                    elif sibling['class'] == ['sbh'] or sibling['class'] == ['sbtx1']:
                        sibling = sibling.find_next_sibling()
                        continue
                    # flavor affinities
                    elif sibling['class'] == ['h4']:
                        sibling = sibling.find_next_sibling()
                        while sibling != None:
                            #c.execute("INSERT INTO matches VALUES ('%s', '', '', '%s', '')" % (i, s))
                            try:
                                if sibling.find_next_sibling()['class'] in (['lh'], ['lh1'], ['p1']):
                                    break
                            except:
                                break
                            sibling = sibling.find_next_sibling()
            
                    # match-low
                    elif sibling.find('strong') == None:
                        addMatches(ingredients, matches, ingredient_ids, id, i, s, 1)
                    else:
                        # match-medium
                        if s.islower():
                            addMatches(ingredients, matches, ingredient_ids, id, i, s, 2)
                        # match-high
                        elif s.isupper() and s.startswith('*') == False:
                            addMatches(ingredients, matches, ingredient_ids, id, i, s, 3)
                        # match-holy
                        elif s.isupper() and s.startswith('*') == True:
                            addMatches(ingredients, matches, ingredient_ids, id, i, s[1:], 4)
            
                    sibling = sibling.find_next_sibling()
    
    
                print('')
    


    writeResultsToJSON('ingredients.json', ingredients)
    writeResultsToJSON('matches.json', matches)

    writeIngredientsToTable(ingredients)
    writeMatchesToTable(matches)

    conn.commit()
    conn.close()
