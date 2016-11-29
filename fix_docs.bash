#!/bin/bash

function comment {
    echo comment out $1
    sed -i "\|$1| s|^|# |" doc/mkdocs/mkdocs.yml
}

for file in `find doc/ -size -1024c`; do
    comment $file
done
