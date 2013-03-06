#!/usr/bin/env bash

# $Id: $

#
# Выполняет поиск коммитов начиная с указанной ревизии
#
# Example: svn-log-tasks.sh 200 FH ^/trunk

START_REVISION=$1
PROJECT_TITLE=$2
BRANCH=$3

if [ -z "$START_REVISION" -o -z "$PROJECT_TITLE" ]; then
	echo
	echo "Use:"
	echo "	$0 <START_REVISION> <PROJECT_TITLE>"
	echo
	echo "Example:"
	echo "	$0 200 FH "
	echo
	exit -1
fi

echo "---------------------------"
echo
echo "Found $PROJECT_TITLE tasks:"
echo
svn log -r $1:HEAD $BRANCH|grep $2-|awk '{print $1}'|sort -u
echo
echo "That's all folks!"
