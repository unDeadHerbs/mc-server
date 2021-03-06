#!/bin/sh

set -xe

##
#  Utility
##

git_claim_tag(){
    git checkout `git rev-parse --short HEAD`
    git b -D "$@"
    git b "$@"
    git checkout "$@"
}


next_differs_head(){
    git diff origin/next HEAD|grep "." >/dev/null
}

##
#  Update and Save Local Copy
##

# TODO: this can fail to make a stash and then pop will be bad in apply_saved

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

update_to_next(){
    git_claim_tag running
    git merge --no-ff origin/next --no-edit
    git submodule sync
    git submodule init
    git submodule foreach --recursive "git submodule init"
    git submodule update --recursive
}

# check for no stash or no commit
apply_saved(){
    git pop
    cd worlds
    git_claim_tag worlds
    git pop
    cd ..
    cd plugins
    git_claim_tag plugins
    git pop
    cd ..
}

check_point_local(){
    git add --all
    git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
    cd worlds
    git add --all
    git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
    cd ..
    cd plugins
    git add --all
    git commit -m "auto commit on `date \"+%Y-%m-%d\"`"
    cd ..
    git add --all
    git commit -m "auto commit sub-modules on `date \"+%Y-%m-%d\"`"
}

update_server(){
    save_local
    if next_differs_head ; then
	update_to_next
    fi
    apply_saved
    check_point_local
}

##
#  Update Github Branches
##

manuver_branches(){
    git_claim_tag next
    git commit --allow-empty -m "separator"
    git checkout running
}

push_to_hub(){
    cd worlds
    git push -f
    cd ..
    cd plugins
    git push -f
    cd ..
    git push -f
    git push origin next -f
}

update_hub(){
    manuver_branches
    push_to_hub
}

##
#  Run the Server
##

start_server(){
    BINDIR=$(dirname "$(readlink -fn "$0")")
    java -Xmx1024M -jar $(ls |grep spi|grep jar|sort -r|head -n 1) --log-append true
}

##
#  Top of Script
##

should_update(){
    git fetch origin next
    { git diff origin/next HEAD|grep "." >/dev/null ; } && {
	git diff HEAD|grep "." >/dev/null ; }
}

should_stop(){
    grep "^[[][-09][0-9]:[0-9][0-9]:[0-9][0-9]([]] [[]Server thread/| )INFO[]]: [[]Server[]] Shutdown$" logs/latest.log
}

while ! should_stop ; do
    if should_update ; then
	update_server
	update_hub
    fi
    start_server
done
