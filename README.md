## About scripts
### svn-merge-tasks.sh
- Script is searching for commits by tasks in JIRA and merge it all to WORKING_COPY.

Install:

<pre>make install</pre>

- Note, this script will remove all that was in the old directory.

After that, you need to set the PATH variable in your .bashrc or .bash_profile.
<pre>export PATH=~/bin:$PATH</pre>

Usage:

- Run in the directory with WORKING_COPY in which you're merging.
<pre> ./svn-merge-tasks.sh SQR-123,SQR-157,SQR-143 ^/trunk 'SQR-200 release build 2.2.1' </pre>
where SQRs are task numbers and ^/trunk is the source.


