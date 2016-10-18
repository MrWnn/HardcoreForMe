#!/bin/bash

echo $#
if [ $#  -eq 0 ]
then
echo -e "\n change A-name.tar.gz to B-name.tar.gz \n "
echo -e " input A-name B-name, no .tar.gz \n "
exit
fi


tar -zxvf $1.tar.gz
mv $1 $2
tar -zcvf $2.tar.gz $2
rm -r $2
rm $1.tar.gz
