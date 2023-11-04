#!/bin/bash

query="${*:-now}"

print_format='+%a %b %d %I:%M %P %Z %Y'
TZ=PST+7 date -d "TZ=\"IST-5:30\" ${query}" "${print_format}"
TZ=CST+5 date -d "TZ=\"IST-5:30\" ${query}" "${print_format}"
TZ=CET-1 date -d "TZ=\"IST-5:30\" ${query}" "${print_format}"
date -d "${query}" "${print_format}"
