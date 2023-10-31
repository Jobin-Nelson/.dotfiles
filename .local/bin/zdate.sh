#!/bin/bash

query="${*:-now}"

TZ=PST+7 date -d "TZ=\"IST-5:30\" ${query}" '+%a %b %d %I:%M %P %Z %Y'
TZ=CST+5 date -d "TZ=\"IST-5:30\" ${query}" '+%a %b %d %I:%M %P %Z %Y'
TZ=CET-1 date -d "TZ=\"IST-5:30\" ${query}" '+%a %b %d %I:%M %P %Z %Y'
date -d "${query}" '+%a %b %d %I:%M %P %Z %Y'
