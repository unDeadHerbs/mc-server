#!/bin/sh

git fetch origin running
git merge --no-ff origin/next --no-edit
git submodule sync
git submodule update --init --recursive
# run update worlds script
cd worlds
# this needs to set the branch because it's detached by default
#if git branch|grep "^[*]"|grep detached
#if `cat ../.git/refs/remotes/origin/worlds` -eq `cat ../.git/modules/worlds/HEAD`
# git checkout worlds
#else
# git checkout worlds
# git branch "worlds-`date \"+%Y-%m-%d\"`"
# git revert place where it was
#fi
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`" --allow-empty
git push && git fetch --depth=1 origin worlds
git gc
cd ..
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
git push
git gc

BINDIR=$(dirname "$(readlink -fn "$0")")
 cd "$BINDIR"
 java -XX:MaxPermSize=128M -XX:-UseGCOverheadLimit -jar $(ls |grep spi|grep jar|sort -r|head -n 1) --log-append true #| tee -a server.log
#-o false
