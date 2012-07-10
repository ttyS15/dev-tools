#!/usr/bin/env bash

# $Id: $

#
# Выполняет создание тега сборки релиза. 
# 
# Example: svn-release.sh 3.x 3.2.0 'SQR-123 - Сборка релиза' http://svn.rutube.ru/squirrel 
# 
# PROJEECT_URL указывать не обязательно, если команда выполняется из какой-либо рабочей копии проекта.
#

STABLE=$1
RELEASE=$2
MESSAGE_HEADER=$3
PROJECT_URL=${4:-^}

if [ -z "$STABLE" -o -z "$RELEASE" -o -z "$MESSAGE_HEADER" ]; then
	echo
	echo "Use:"
	echo "	$0 STABLE RELEASE MESSAGE_HEADER [ PROJECT_URL ]"
	echo
	echo "Example:"
	echo "	$0 3.x 3.2.0 'SQR-123 - Сборка релиза' http://svn.rutube.ru/squirrel"
	echo
	exit 127
fi

STABLE_URL="$PROJECT_URL/branches/stable/$STABLE"
RELEASE_URL="$PROJECT_URL/tags/release/$RELEASE"

echo
echo "STABLE URL = $STABLE_URL"
echo "RELEASE URL = $RELEASE_URL"
echo "MESSAGE_HEADER = $MESSAGE_HEADER"
echo

#if [ -n "$MESSAGE_HEADER" ]; then 
#	echo "$MESSAGE_HEADER" > commit-message.txt
#else
#	echo -n > commit-message.txt
#fi
#
#echo >> commit-message.txt
#echo "Request revisions from $SOURCE:" >> commit-message.txt
#echo >> commit-message.txt
#
#svn up
#
#TASKS=`echo "$TASKS" | sed -e 's/,/|/'`
#
#svn log -l 100 "$SOURCE" | grep -E "^($TASKS)" -B2 | awk -F '|' ' NR%4==1 {system("echo -n " $1 " >> commit-message.txt "); rev=substr($1,2); print rev;} NR%4==3 {system("echo \" \"" $0 " >> commit-message.txt");}' | sort -n | xargs -Irev svn merge -crev $SOURCE
#
#echo
#echo "COMMIT MESSAGE"
#echo 
#cat commit-message.txt
#echo
#
#COMMIT_COMMAND="svn ci -F commit-message.txt"
#
#
#echo "COMMIT COMMAND"
#echo
#echo "$COMMIT_COMMAND"
#echo 
#
#while [ 1 ]; do
#	echo -n 'Do you have fastened the seat belt? (yes/no) [no]:'
#	read DO_IT_MOTHER_FUCKER
#
#	if [ "$DO_IT_MOTHER_FUCKER" = 'yes' ]; then 
#		echo "God bless you! Go..."
#		`$COMMIT_COMMAND`
#		exit 0
#	elif [ -z "$DO_IT_MOTHER_FUCKER" -o "$DO_IT_MOTHER_FUCKER" = 'no' ]; then
#		echo "Looser!"
#		exit 127
#	fi
#
#	echo
#	echo "This is your last chance! What is your choice: yes or no?"
#	echo 
#
#done
