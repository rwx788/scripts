#!/bin/bash
if [ $# -ne 3 ]
  then
    echo "Not enough parameters supplied. Expect <number of users to create> <name_prefix> <password>."
fi

count=$1;
prefix=$2;
password=$3;

if [ $(id -u) -eq 0 ]; then
     for i in `seq 1 $count`;
     do
        username="$prefix_$i"
      	egrep "^$username" /etc/passwd >/dev/null
      	if [ $? -eq 0 ]; then
      		echo "$username exists!"
      		exit 1
      	else
      		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
      		useradd -m -p $pass $username
      		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
      	fi
    done
else
	echo "Only root may add a user to the system"
	exit 2
fi
