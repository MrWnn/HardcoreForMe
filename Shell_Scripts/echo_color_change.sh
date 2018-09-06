#!/bin/bash

Text="$1"

# 标绿
Green(){
    echo -e "\n\033[1;32m$*\033[0m\n"
}

# 标红
Red() {
    echo -e "\n\033[1;31m$*\033[0m\n"
}

Green $0
Green "${Text}"
Red $0
Red  "${Text}"
