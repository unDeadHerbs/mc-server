#!/bin/sh

update_server(){
    git fetch
    git s
    git checkout `git rev-parse --short HEAD`
    git rh
    git b -d running
    git b running
    git checkout running
    git pop
    git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
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
    git checkout `git rev-parse --short HEAD`
    git b -d worlds
    git b worlds
    git checkout worlds
    git pop
    git add --all
    git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
    git push -f
    cd ..
    cd plugins
    git checkout `git rev-parse --short HEAD`
    git b -d plugins
    git b plugins
    git checkout plugins
    git pop
    git add --all
    git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
    git push -f
    cd ..
    git pop
    git add --all
    git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
    git push -f
    git gc
}

start_server(){
    BINDIR=$(dirname "$(readlink -fn "$0")")
    cd "$BINDIR"
    java -Xmx1024M -jar $(ls |grep spi|grep jar|sort -r|head -n 1) --log-append true
}

update_server
start_server
