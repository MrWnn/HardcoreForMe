#!/bin/bash

# value tester that retun error info if string empty then exit else if  normal then echo value
a=$1 && [[ $a = "" ]] && echo empty && exit || echo  "pass \$1 : $a"

