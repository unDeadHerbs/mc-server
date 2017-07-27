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
    git b -D "$@"
    git b "$@"
    git checkout "$@"
}

update_to_next(){
    git_claim_tag running
    git merge --no-ff origin/next --no-edit
    git submodule sync
    git submodule init
    git submodule foreach --recursive "git submodule init"
    git submodule update --recursive
}

next_differs(){
    git diff origin/next HEAD|grep "." >/dev/null
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
    if next_differs ; then
	update_to_next
    fi
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
    git push origin next -f
}

seperate_next(){
    git checkout next
    git reset running
    git commit --allow-empty -m "separator"
    git checkout running
}

update_hub(){
    seperate_next
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

should_update(){
    git fetch origin next
    git diff origin/next HEAD|grep "." >/dev/null
}

should_stop(){
    grep logs/latest.log "^[[][-09][0-9]:[0-9][0-9]:[0-9][0-9]([]] [[]Server thread/| )INFO[]]: [[]Server[]] Shutdown$"
}

while ! should_stop ; do
    if should_update ; then
	update_server
	update_hub
    fi
    start_server
done
