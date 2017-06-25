#!/bin/sh

git fetch
git b -d running
git b running
git checkout running
git merge --no-ff origin/next --no-edit
git submodule sync
git submodule init --recursive
# run update worlds script
cd worlds
git s
cd ..
cd plugins
git s
cd ..
git submodule update --recursive
cd worlds
git b -d worlds
git b worlds
git checkout worlds
git pop
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
git push -f
cd ..
cd plugins
git b -d plugins
git b plugins
git checkout plugins
git pop
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
git push -f
cd ..
git add --all
git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
git push -f
git gc

BINDIR=$(dirname "$(readlink -fn "$0")")
 cd "$BINDIR"
 java -XX:MaxPermSize=128M -XX:-UseGCOverheadLimit -jar $(ls |grep spi|grep jar|sort -r|head -n 1) --log-append true #| tee -a server.log
#-o false
