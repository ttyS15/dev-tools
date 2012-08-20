Script is searching for commits by tasks in JIRA and merge it all to WORKING_COPY.


Usage:

./svn-merge-tasks.sh SQR-123,SQR-157,SQR-143 ^/trunk 'SQR-200 release build 2.2.1'
where SQR's are tasks numbers and ^/trunk is the source.

Run in the directory with WORKING_COPY in which you're merging.
