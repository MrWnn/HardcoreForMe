#!/bin/bash

LOAD(){
    dirname=$(mktemp -d -t tmp.XXXXXXXXXXXX)
}

FIRE(){
    echo -e "\033[33m do something in $dirname  \033[0m"
}

RELOAD(){
    rm -rf $dirname
}

LOAD
FIRE
trap RELOAD EXIT

#this provide a secure way to clean template data created by shell script
#on EXIT , trap will execute RELOAD function
#and the code in RELOAD function can be replace by any other logic you want
