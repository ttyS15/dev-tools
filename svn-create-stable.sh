#!/usr/bin/env bash

# $Id: $

#
# Выполняет создание stable на основе версии и JIRA task key,
# копируя в stable указанную ветку
#
# Example: svn-create-stable.sh 1.x SQR-1234 http://svn.rutube.ru/squirrel/
# Example: svn-create-stable.sh 1.0.x SQR-1234 http://svn.rutube.ru/squirrel/branches/stable/1.x
# Example: svn-create-stable.sh 1.x SQR-1234
#

VERSION=$1
TASK_KEY=$2
SOURCE=$3

#
# Проверяем обязательные параметры, печатаем хелп
#
if [ -z "$VERSION" -o -z "TASK_KEY" ]; then
	echo
	echo "Use:"
	echo "$0 VERSION TASK_KEY [SOURCE]"
	echo
	echo "Example:"
	echo "$0 1.x SQR-1234 http://svn.rutube.ru/squirrel/"
	echo "$0 1.0.x SQR-1234 http://svn.rutube.ru/squirrel/branches/stable/1.x"
	echo "$0 1.x SQR-1234"
	echo
	exit 127
fi

#
# генерируем SOURCE по-умолчанию - это URL текущей рабочей копии
#
if [ -z "$SOURCE" ]; then
    SOURCE=`svn info --xml|sed -e '/^<url>/!d'|sed -e 's/<\/\?url>//g'`
fi

#
# получаем корень репозитория
#

# SVN_ROOT=`svn info --xml $SOURCE|sed -e '/^<root>/!d'|sed -e 's/<\/\?root>//g'`
# можно было бы использовать информацию о корне SVN, но для конвертера
# и python_lib это не подходит
SVN_ROOT=`echo $SOURCE|sed -e 's/\/trunk$//'`

#
# Проверяем, что в аргументах не указан ROOT репозитория и
# заменяем его на trunk
#

if [ $SOURCE = $SVN_ROOT ]; then
    echo "SVN_ROOT equals SOURCE, adding trunk"
    TRUNK=trunk
    SOURCE=`echo $SOURCE$TRUNK`
fi

BRANCHES_DIR=`echo $SVN_ROOT/branches/stable`
TAGS_DIR=`echo $SVN_ROOT/tags/release`
STABLE_DIR=`echo $BRANCHES_DIR/$VERSION`

echo
echo "VERSION = $VERSION"
echo "SOURCE = $SOURCE"
echo "TASK_KEY = $TASK_KEY"
echo "BRANCHES_DIR = $BRANCHES_DIR"
echo

echo "Checking stable dir..."
CMD="svn info $BRANCHES_DIR"
echo $CMD
eval "$CMD 1>/dev/null 2>/dev/null"
RETVAL=$?

if [ $RETVAL -ne 0 ]; then
    echo -n "$TASK_KEY creating stable dir" > commit-message.txt
    CMD="svn mkdir --parents $BRANCHES_DIR -F commit-message.txt"
    echo $CMD
    $CMD
fi

echo
echo "Checking tags dir..."
CMD="svn info $TAGS_DIR"
echo $CMD
eval "$CMD 1>/dev/null 2>/dev/null"
RETVAL=$?

if [ $RETVAL -ne 0 ]; then
    echo -n "$TASK_KEY creating tags dir" > commit-message.txt
    CMD="svn mkdir --parents $TAGS_DIR -F commit-message.txt"
    echo $CMD
    $CMD
fi


echo
echo "Checking for stable existance"
CMD="svn info $STABLE_DIR"
echo $CMD
eval "$CMD 1>/dev/null 2>/dev/null"
RETVAL=$?

if [ $RETVAL -ne 0 ]; then
    echo -n "$TASK_KEY creating stable $VERSION" > commit-message.txt
    CMD="svn cp $SOURCE $STABLE_DIR -F commit-message.txt"
    echo $CMD
    $CMD
fi

