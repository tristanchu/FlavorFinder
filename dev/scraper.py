"""
Scraper for the 'The Flavor Bible'.
"""
#!/usr/env/python

import ebooklib
from ebooklib import epub
from bs4 import BeautifulSoup
import sqlite3
import re

conn = sqlite3.connect('flavors.db')
c = conn.cursor()
c.execute('''CREATE TABLE flavors
            (ingredient text, match_low text, match_medium text,
            match_high text, match_holy text, season text, taste text, 
            weight text, volume text, affinity text, quote text)''')

book = epub.read_epub('flavorbible.epub')
result = ""
for item in book.get_items():
    type = item.get_type()
    if type == ebooklib.ITEM_DOCUMENT:
        soup = BeautifulSoup(item.content, 'lxml')

        # Find ingredient listings.
        for i in soup.find_all('p', {'class' : ['lh', 'lh1']}):
            print('HEADING: ', i)

            itext = re.sub(r'\s?\(See also.*\)', '', i.text)
            
            # Find what goes well with these ingredients.
            s = i.find_next_sibling()
            while s != None:
                try:
                    if s['class'] in (['lh'], ['lh1']):
                        break
                except:
                    break
                print('content: ', s)
                
                # season, taste, weight, volume
                if s.text.startswith('Season:'):
                    c.execute("INSERT INTO flavors VALUES ('%s', '', '', '', '', '%s', '', '', '', '', '')" % (itext.lower(), s.text[8:]))
                elif s.text.startswith('Taste:'):
                    c.execute("INSERT INTO flavors VALUES ('%s', '', '', '', '', '', '%s', '', '', '', '')" % (itext.lower(), s.text[7:]))
                elif s.text.startswith('Weight:'):
                    c.execute("INSERT INTO flavors VALUES ('%s', '', '', '', '', '', '', '%s', '', '', '')" % (itext.lower(), s.text[8:]))
                elif s.text.startswith('Volume:'):
                    c.execute("INSERT INTO flavors VALUES ('%s', '', '', '', '', '', '', '', '%s', '', '')" % (itext.lower(), s.text[8:]))

                # quote
                elif s['class'] == ['p1']:
                    quote = s.text
                    s = s.find_next_sibling()
                    quote += ' ' + s.text
                    c.execute("INSERT INTO flavors VALUES ('%s', '', '', '', '', '', '', '', '', '', '%s')" % (itext.lower(), quote))
                # flavor affinities
                elif s['class'] == ['h4']:
                    s = s.find_next_sibling()
                    while s != None:
                        c.execute("INSERT INTO flavors VALUES ('%s', '', '', '', '', '', '', '', '', '%s', '')" % (itext.lower(), s.text))

                        try:
                            if s.find_next_sibling()['class'] in (['lh'], ['lh1'], ['p1']):
                                break
                        except:
                            break
                        s = s.find_next_sibling()
                # match-low
                elif s.find('strong') == None:
                    c.execute("INSERT INTO flavors VALUES ('%s', '%s', '', '', '', '', '', '', '', '', '')" % (itext.lower(), s.text.lower()))
                else:
                    # match-medium
                    if s.text.islower():
                        c.execute("INSERT INTO flavors VALUES ('%s', '', '%s', '', '', '', '', '', '', '', '')" % (itext.lower(), s.text.lower()))
                    # match-high
                    elif s.text.isupper() and s.text.startswith('*') == False:
                        c.execute("INSERT INTO flavors VALUES ('%s', '', '', '%s', '', '', '', '', '', '', '')" % (itext.lower(), s.text.lower()))
                    # match-holy
                    elif s.text.isupper() and s.text.startswith('*') == True:
                        c.execute("INSERT INTO flavors VALUES ('%s', '', '', '', '%s', '', '', '', '', '', '')" % (itext.lower(), s.text.lower()[1:]))

                s = s.find_next_sibling()
            print('')

conn.commit()
conn.close()
