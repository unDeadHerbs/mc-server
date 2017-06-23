#!/bin/sh

git fetch origin running
git merge --no-ff origin/next --no-edit
git submodule sync
git submodule --init --recursive
# run update worlds script
cd worlds
# this needs to set the branch because it's detached by default
#if git branch|grep "^[*]"|grep detached
#if `cat ../.git/refs/remotes/origin/worlds` -eq `cat ../.git/modules/worlds/HEAD`
# git checkout worlds
#else
# stash
# git checkout worlds
# git branch "worlds-`date \"+%Y-%m-%d\"`"
# git revert place where it was
# git revert to clean
# git pop
#fi
git s
git checkout worlds
git pull
git pop
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`" --allow-empty
git push
cd ..
cd plugins
git s
git checkout plugins
git pull
git pop
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`" --allow-empty
git push
cd ..
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
git push
git gc

BINDIR=$(dirname "$(readlink -fn "$0")")
 cd "$BINDIR"
 java -XX:MaxPermSize=128M -XX:-UseGCOverheadLimit -jar $(ls |grep spi|grep jar|sort -r|head -n 1) --log-append true #| tee -a server.log
#-o false
