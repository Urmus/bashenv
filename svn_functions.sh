# Get MD5 checksum of a file in uppercase, and only checksum (no filename) so it can be used easily in pipes
function md5 {
	md5sum "$1" | cut -d" " -f1 | tr 'a-z' 'A-Z'
}

# Get SVN rev of a file
function svnrev {
	if [ $# -eq 1 ]
	then
		svn status -v "$fic" | cut -b19-27 | tr -d ' '
	else
		return 1
	fi
	return 0
}

# Get the SVN revision of all files recursively in the directory
function svnallrev {
	if [ ! -d "$1" ]
	then
		echo "Syntax: svnallrev <directory>"
		return 1
	else
		find "$1" -type f | while read fic
		do
			rev=$(svnrev "$fic")
			if [ ! $rev = "" ]
			then
				printf "%d %s\n" $rev "$fic"
			fi
		done
	fi
}

# Format a report of directory for documents: get recursively: filename, SVN revision and md5 checksum, on screen and in a CSV
function svnreport {
	if [ ! -d "$1" ]
	then
		echo "Syntax: svnallrev <directory>"
		return 1
	else
		csv="$1/sci_report.csv"
		> "$csv"
		if [ $? -ne 0 ]
		then
			echo "Error: cannot write to $csv"
			return 1
		fi
		find "$1" -type f | while read fic
		do
			rev=$(svnrev "$fic")
			if [ ! $rev = "" ]
			then
				checksum=$(md5 "$fic")
				printf "%d %s %s\n" $rev $checksum "$fic"
				printf "%s;%s;%d\n" "$fic" $checksum $rev >> "$csv"
			fi
		done
		open "$csv"
	fi
}

# Get last SVN log entry for the current directory
function svnlastlog {
    svn update
    if [ $# -eq 1 ]
    then
        if [ $1 -ge 1 ]
        then
            svn log -l $1 -v
        else
            echo "Error: number expected, or nothing"
        fi
    else
        svn log -l 1 -v
    fi
}
