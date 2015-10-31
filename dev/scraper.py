#!/usr/bin/env python
"""
Scraper for the 'The Flavor Bible'.

Created by Jon.
"""

import ebooklib
from ebooklib import epub
from bs4 import BeautifulSoup
import sqlite3
import re
import csv


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

def addMatches(ingredients, matches, ingredient_ids, id, i, s, match_level):
    global latest_id

    if s.lower() in ingredient_ids:
        match_id = ingredient_ids[s.lower()]
    else:
        match_id = latest_id
        ingredients[match_id] = [match_id, s, '', '', '', '', '1', '0', '0', '0']
        ingredient_ids[s.lower()] = match_id
        latest_id += 1

    match1 = str(id) + '_' + str(match_id)
    match2 = str(match_id) + '_' + str(id)

    if not match1 in matches:
        matches[match1] = [id, match_id, match_level, '0', '0', '', '']
    if not match2 in matches:
        matches[match2] = [match_id, id, match_level, '0', '0', '', '']


def writeIngredientsToCSV(filename, fieldnames, data):
    with open(filename, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, delimiter='|', fieldnames=fieldnames)
        writer.writeheader()
        for key in data:
            row = data[key]
            print(row)
            writer.writerow({fieldnames[0]: row[0], fieldnames[1]: row[1], fieldnames[2]: row[2], 
                             fieldnames[3]: row[3], fieldnames[4]: row[4], fieldnames[5]: row[5],
                             fieldnames[6]: row[6], fieldnames[7]: row[7], fieldnames[8]: row[8],
                             fieldnames[9]: row[9]})

def writeMatchesToCSV(filename, fieldnames, data):
    with open(filename, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, delimiter='|', fieldnames=fieldnames)
        writer.writeheader()
        for key in data:
            row = data[key]
            writer.writerow({fieldnames[0]: row[0], fieldnames[1]: row[1], fieldnames[2]: row[2], 
                             fieldnames[3]: row[3], fieldnames[4]: row[4]})

def writeIngredientsToTable(data):
    for key in data:
        row = data[key]
        c.execute("INSERT INTO ingredients VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')" % (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9]))

def writeMatchesToTable(data):
    for key in data:
        row = data[key]
        c.execute("INSERT INTO matches VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s')" % (row[0], row[1], row[2], row[3], row[4], row[5], row[6]))



if __name__ == '__main__':
    global latest_id
    ingredients_fieldnames = ['id', 'name', 'season', 'taste', 'weight', 'volume', 'vegetarian', 'dairy', 'kosher', 'nuts']
    matches_fieldnames = ['name', 'match', 'match_level', 'upvotes', 'downvotes', 'affinity', 'quote']

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

                i = re.sub(r'\s?\(See also.*\)', '', ingredient.text)
                i = i.lower()
            
                if i in ingredient_ids:
                    id = ingredient_ids[i]
                else:
                    id = latest_id
                    ingredients[id] = [id, i, '', '', '', '', 1, 0, 0, 0]
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
                        ingredients[id][2] = s[8:]
                    elif s.startswith('Taste:'):
                        ingredients[id][3] = s[7:]
                    elif s.startswith('Weight:'):
                        ingredients[id][4] = s[8:]
                    elif s.startswith('Volume:'):
                        ingredients[id][5] = s[8:]
            
                    # quote
                    elif sibling['class'] == ['p1']:
                        quote = s
                        sibling = sibling.find_next_sibling()
                        s = sibling.text
                        quote += ' ' + s
                        #c.execute("INSERT INTO matches VALUES ('%s', '', '', '', '%s')" % (i, quote))
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
    
    writeIngredientsToCSV('ingredients.csv', ingredients_fieldnames, ingredients)
    writeMatchesToCSV('matches.csv', matches_fieldnames, matches)

    writeIngredientsToTable(ingredients)
    writeMatchesToTable(matches)

    conn.commit()
    conn.close()
