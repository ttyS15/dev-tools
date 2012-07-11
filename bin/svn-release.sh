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
MESSAGE_HEADER=${3:-'Automated release builder'}
PROJECT_URL="${4:-^}"

STABLE_BASE="$PROJECT_URL/branches/stable"
RELEASE_BASE="$PROJECT_URL/tags/release"


if [ -z "$STABLE" -o -z "$RELEASE" -o -z "$MESSAGE_HEADER" ]; then
	echo
	echo "Use:"
	echo "	$0 STABLE RELEASE [ MESSAGE_HEADER [ PROJECT_URL ] ]"
	echo
	echo "Example:"
	echo "	$0 3.x 3.2.0 'SQR-123 - Сборка релиза' http://svn.rutube.ru/squirrel"
	echo
	exit -1
fi

STABLE_URL="$STABLE_BASE/$STABLE"
RELEASE_URL="$PROJECT_URL/tags/release/$RELEASE"

RELEASE_DIR=`svn ls $RELEASE_BASE | grep -E "^$RELEASE/"`

if [ -z $RELEASE_DIR ]; then
	svn mkdir -m "$MESSAGE_HEADER : Create dir for release $RELEASE" $RELEASE_URL || exit -1
	BUILD_URL="$RELEASE_URL/01"
else
	# Получаем номер крайнего билда в релизе и увеичиваем на 1
	BUILD=`svn ls $RELEASE_URL | grep -E '[0-9]{2}/' | tail -1 | colrm 3`
	BUILD=$((BUILD+1))
	BUILD=`printf '%02d' $BUILD`
fi

BUILD_URL="$RELEASE_URL/$BUILD"

COMMAND="svn cp -m '$MESSAGE_HEADER : Create release build $RELEASE-$BUILD' '$STABLE_URL' '$BUILD_URL'"

echo
echo "Ok, you are going to do this shit:"
echo 
echo "	$COMMAND"
echo
echo "Do you really know what do you do?"
echo "If so, just type 'yes' and we will see do you have nuts such stronger as you think."
echo -n "So, what is your bet? (yes/[no])"

while [ 1 ]; do
	
	read DO_IT_MOTHER_FUCKER

	if [ "$DO_IT_MOTHER_FUCKER" = 'yes' ]; then
		echo
		echo "Hold on to your chair! Go..."
		eval $COMMAND || exit -1
		echo
		exit 0
	elif [ -z "$DO_IT_MOTHER_FUCKER" -o "$DO_IT_MOTHER_FUCKER" = 'no' ]; then
		echo
		echo "Stay away from men's work!"
		echo
		exit -1
	fi

	echo
	echo -n "What I see? Are you real strong man with big balls or just pretty virgin? Lets check? (yes/[no])"

done
