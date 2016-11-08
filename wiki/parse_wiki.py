#!/usr/bin/python2
## Usage:
## for file in `find . -name *.html`; do ./parse_wiki.py $file; done

import sys, os, re
from HTMLParser import HTMLParser

class WikiParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.recording = 0
        self.data = []

    def handle_starttag(self, tag, attributes):
        if tag != 'div':
            return
        if self.recording:
            self.recording += 1
            return
        for name, value in attributes:
            if name == 'id' and value == 'main-content':
                break
        else:
            return
        self.recording = 1

    def handle_endtag(self, tag):
        if tag == 'div' and self.recording:
            self.recording -= 1

    def handle_data(self, data):
        if self.recording:
            self.data.append(data)

html = open(sys.argv[1], 'r')
wp = WikiParser()

wp.feed(html.read())
md = open(os.path.splitext(sys.argv[1])[0] + ".md", 'w')

for line in wp.data:
    if not re.match('^\s+$', line):
        md.write("%s\n" % line)

wp.close()
md.close()
html.close()

os.remove(sys.argv[1])
