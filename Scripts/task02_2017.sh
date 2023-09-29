#1/bin/bash

find $1  -type f -user $(whoami) 2> /dev/null
