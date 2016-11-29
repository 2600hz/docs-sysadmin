#!/usr/bin/python

import yaml, os.path

def parse_page(page):
    "parse a page for existence"
    if isinstance(page, dict):
        for header, pages in page.items():
            if pages is None:
                print "section ", header, " is incomplete"
            else:
                parse_page(pages)
    elif isinstance(page, list):
        for p in page:
            parse_page(p)
    elif isinstance(page, str):
        if "index.md" != page and (not os.path.isfile(page)):
            print "page ", page, " is not valid"

stream = open("doc/mkdocs/mkdocs.yml", 'r')
mkdocs = yaml.load_all(stream)

for doc in mkdocs:
    for k,v in doc.items():
        if "pages" == k:
            parse_page(v)
