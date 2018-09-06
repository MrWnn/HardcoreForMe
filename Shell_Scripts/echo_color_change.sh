#!/bin/bash

Text="$1"

# 标绿
Green() {
    echo "|font color="green"||b|$@|^b| ||font|"
}

# 标红
Red() {
    echo "|font color="red"||b|$@|^b| ||font|"
}

Green $0
Green "${Text}"
Res $0
Red  "${Text}"
