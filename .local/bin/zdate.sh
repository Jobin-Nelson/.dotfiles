#!/bin/bash

query="${*:-now}"

print_format='+%a %b %d %I:%M %P %Z %Y'
TZ=PST+7 date -d "TZ=\"UTC\" ${query}" "${print_format}"
TZ=CST+5 date -d "TZ=\"UTC\" ${query}" "${print_format}"
TZ=CET-2 date -d "TZ=\"UTC\" ${query}" "${print_format}"
date -d "${query}" "${print_format}"
