#!/bin/bash
hash  uuidgen > /dev/null 2>&1
if [ $? == "0" ];then
New-Giud(){
  uuidgen $*
}
else
New-Guid() {
  first=`LC_ALL=C tr -dc a-f0-9 < /dev/urandom  |
    dd bs=8 count=1 2> /dev/null`
  second=`LC_ALL=C tr -dc a-f0-9 < /dev/urandom |
    dd bs=4 count=1 2> /dev/null`
  third=`LC_ALL=C tr -dc a-f0-9 < /dev/urandom  |
    dd bs=4 count=1 2> /dev/null`
  fourth=`LC_ALL=C tr -dc a-f0-9 < /dev/urandom |
    dd bs=12 count=1 2> /dev/null`
  printf "$first-$second-$third-$fourth"
}
fi