#!/bin/bash

# use
#find -maxdepth 1 -type l|cut -d / -f 2|xargs 
# to find a list of the world files
# TODO: have that check that they link to /worlds

# remove from /worlds any that are not linked to (removed by MultiVerse)

# move into the /worlds folder any worlds found outside of it
# (not sure how to do that, prehaps check untracked folders?)

# create a simlink to every folder in /worlds
for wrd in $(ls worlds)
do
    ln -sf "worlds/$wrd" "$wrd"
done
# (don't re-make ones that already exist)
