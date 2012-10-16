#!/usr/bin/env bash

# $Id: $

#
# Выполняет сборку пакета
#
# Example: svn-build.sh encoder-7.0.6 http://svn.rutube.ru/converter/pyco2 

WORKDIR="/tmp"
VREPO="http://y.rutube.ru/vrepo/"
PACKAGE_NAME=$1
PROJECT_URL=$2

if [ -z "$PACKAGE_NAME" -o -z "$PROJECT_URL" ]; then
	echo
	echo "Use:"
	echo "	$0 <PROJECT>-<VERSION> <SVN_PROJECT_ROOT>"
	echo
	echo "Example:"
	echo "	$0 encoder-7.0.6 http://svn.rutube.ru/converter/pyco2"
	echo
	exit -1
fi

PRODUCT_NAME=${PACKAGE_NAME%-*}
VERSION=${PACKAGE_NAME#*-}

RELEASE_BASE="$PROJECT_URL/tags/release"
RELEASE_URL="$RELEASE_BASE/$VERSION"

# Получаем номер крайнего билда в релизе и увеичиваем на 1
BUILD=`svn ls $RELEASE_URL | grep -E '[0-9]{2}/' | tail -1 | colrm 3`
BUILD=${BUILD:-0} # Значение по умолчанию, если билдов нет
BUILD=`printf '%02s' $BUILD`
BUILD_NAME="$PACKAGE_NAME-$BUILD"
ARCHIVE_NAME="$BUILD_NAME.tgz"
cd $WORKDIR

svn export $RELEASE_URL/$BUILD $BUILD_NAME
tar cvzf $ARCHIVE_NAME $BUILD_NAME

COMMAND="curl -T $ARCHIVE_NAME $VREPO$PRODUCT_NAME/$ARCHIVE_NAME"

echo "---------------------------"
echo
echo "Created tarball $WORKDIR/$ARCHIVE_NAME"
echo
echo "Next command is:"
echo
echo "	$COMMAND"
echo
echo "Upload to vrepo? [yes/no]"

while [ 1 ]; do
	
	read DO_IT_MOTHER_FUCKER
	if [ "$DO_IT_MOTHER_FUCKER" = 'yes' ]; then
		echo
		echo "Hold on to your chair! Go..."
		eval $COMMAND && exit -1
	elif [ -z "$DO_IT_MOTHER_FUCKER" -o "$DO_IT_MOTHER_FUCKER" = 'no' ]; then
		echo
		echo "Stay away from men's work!"
		echo
		exit -1
	fi

done




