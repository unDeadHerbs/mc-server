#!/bin/sh

set -xe

##
#
##

save_local(){
    git stash
    # run update worlds script
    cd worlds
    git stash
    cd ..
    cd plugins
    git stash
    cd ..
}

git_claim_tag(){
    git checkout `git rev-parse --short HEAD`
    git b -d "$@"
    git b "$@"
    git checkout "$@"
}

update_to_next(){
    git fetch
    git_claim_tag running
    git merge --no-ff origin/next --no-edit
    git submodule sync
    git submodule init
    git submodule foreach --recursive "git submodule init"
    git submodule update --recursive
}

apply_local(){
    git pop
    git add --all
    git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
    cd worlds
    git_claim_tag worlds
    git pop
    git add --all
    git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
    cd ..
    cd plugins
    git_claim_tag plugins
    git pop
    git add --all
    git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
    cd ..
    git add --all
    git commit -m "auto commit sub-modules on `date \"+%Y-%m-%d\"`"
}

update_server(){
    save_local
    update_to_next
    apply_local
    git gc
}

##
#
##

push_to_hub(){
    cd worlds
    git push -f
    cd ..
    cd plugins
    git push -f
    cd ..
    git fetch
    git push -f
}

update_hub(){
    push_to_hub
}

##
#
##

start_server(){
    BINDIR=$(dirname "$(readlink -fn "$0")")
    java -Xmx1024M -jar $(ls |grep spi|grep jar|sort -r|head -n 1) --log-append true
}

##
#
##

should_stop(){
    grep logs/latest.log "^[[][-09][0-9]:[0-9][0-9]:[0-9][0-9][]] [[]Server thread/INFO[]]: [[]Server[]] Shutdown$"
}

while ! should_stop ; do
    update_server
    update_hub
    start_server
done
