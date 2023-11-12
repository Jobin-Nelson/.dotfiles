#!/bin/bash

query="${*:-now}"

print_format='+%a %b %d %I:%M %P %Z %Y'
TZ=PST+8 date -d "TZ=\"IST-5:30\" ${query}" "${print_format}"
TZ=CST+6 date -d "TZ=\"IST-5:30\" ${query}" "${print_format}"
TZ=CET-2 date -d "TZ=\"IST-5:30\" ${query}" "${print_format}"
date -d "${query}" "${print_format}"
