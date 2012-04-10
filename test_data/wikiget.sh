#!/bin/sh

if [ $# -eq 0 ]
then
    echo "Must specify Wikipedia article name, e.g. Dave_Thomas_(American_businessman)"
    exit 1
else
    ARTICLE="$1";
fi

OUTPUT_FILE="$2"

wget -qO- "http://en.wikipedia.org/w/index.php?action=raw&title=$ARTICLE" > $OUTPUT_FILE
