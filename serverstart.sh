#!/bin/sh

git s
git fetch
git merge --no-ff origin/next --no-edit
git submodule sync
git submodule --init --recursive
# run update worlds script
cd worlds
git s
git checkout worlds
git pull
git pop
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
git push
cd ..
cd plugins
git s
git checkout plugins
git pull
git pop
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
git push
cd ..
git pop
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
git push
git gc

BINDIR=$(dirname "$(readlink -fn "$0")")
 cd "$BINDIR"
 java -XX:MaxPermSize=128M -XX:-UseGCOverheadLimit -jar $(ls |grep spi|grep jar|sort -r|head -n 1) --log-append true #| tee -a server.log
#-o false
