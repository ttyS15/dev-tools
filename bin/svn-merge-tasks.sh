#!/usr/bin/env bash

# $Id: $

#
# Выполняет сборку коммитов из источника по номерам задач, мержит их в текущюю 
# директорию (должна быть WORKING_COPY), составляет подробный commit message и
# выполняет коммит с согласия пользователя.
#
# Example: svn-merge-tasks.sh 'SQR-1,SQR-2,SQR-3' ^/trunk 'SQR-1234 Мерж в stable'
# 

TASKS=$1
SOURCE=$2
MESSAGE_HEADER=$3

if [ -z "$TASKS" -o -z "$SOURCE" ]; then
	echo
	echo "Use:"
	echo "$0 TASKS SOURCE [ MESSAGE_HEADER ]"
	echo
	echo "Example:"
	echo "$0 'SQR-1,SQR-2,SQR-3' ^/trunk 'SQR-1234 Мерж в stable'"
	echo
	exit 127
fi

echo
echo "TASKS = $TASKS"
echo "SOURCE = $SOURCE"
echo "MESSAGE_HEADER = $MESSAGE_HEADER"
echo

if [ -n "$MESSAGE_HEADER" ]; then 
	echo "$MESSAGE_HEADER" > commit-message.txt
else
	echo -n > commit-message.txt
fi

echo >> commit-message.txt
echo "Request revisions from $SOURCE:" >> commit-message.txt
echo >> commit-message.txt

svn up

TASKS=`echo "$TASKS" | sed -e 's/,/|/g' | sed -e 's/ //g'`

svn log -l 100 "$SOURCE" | grep -E "^($TASKS)" -B2 | awk -F '|' '
	NR%4==1 {system("echo -n " $1 " >> commit-message.txt "); rev=substr($1,2); print rev;} 
	NR%4==3 {system("echo \" " $0 "\" >> commit-message.txt");}
' | sort -n | xargs -Irev svn merge --non-interactive -c rev $SOURCE

echo
echo "COMMIT MESSAGE"
echo 
cat commit-message.txt
echo

COMMIT_COMMAND="svn ci -F commit-message.txt"

echo "COMMIT COMMAND"
echo
echo "$COMMIT_COMMAND"
echo 

while [ 1 ]; do
	echo -n 'Do you have fastened the seat belt? (yes/no) [no]:'
	read DO_IT_MOTHER_FUCKER

	if [ "$DO_IT_MOTHER_FUCKER" = 'yes' ]; then 
		echo "God bless you! Go..."
		$COMMIT_COMMAND
		exit 0
	elif [ -z "$DO_IT_MOTHER_FUCKER" -o "$DO_IT_MOTHER_FUCKER" = 'no' ]; then
		echo "Looser!"
		exit 127
	fi

	echo
	echo "This is your last chance! What is your choice: yes or no?"
	echo 

done
