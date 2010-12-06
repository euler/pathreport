#!/bin/bash
#
# Help figure out PATH settings
#

#
# The support functions
#

# Emit break between output sections 
br() {
  echo "-----"
}

# Show each path element as a separate line
aslines() {
  echo $PATH | tr : '\n'
}

# Show only live (existing) paths
livepaths() {
for f in `aslines`
do
  # Ignore things that are not existing directories
  [[ -d $f ]] && echo $f
done
}

# Show all files reachable on PATH directories
pathfiles() {
  find `livepaths` -type f -maxdepth 1
}

#
# The various reports
#

echo 'echo $PATH'
echo '----------'
echo $PATH
br

echo "Path elements (" $( aslines | wc -l ) "entries ):"
aslines
br

echo "Issues: "
for f in `aslines`
do
  [[ ! -d $f ]] && echo "Not a directory, ignoring: " $f
done
br

echo '#Bytes'	"	" In PATH tree
du -hs `livepaths`
br

echo '#Files'	"	" "In each PATH directory"
for f in `livepaths`
do
  echo $(find $f -type f -maxdepth 1 | wc -l) "	" $f
done
br

echo "Files duplicated in PATH"
echo "#copies"
pathfiles | sed -e 's=^.*/==' | sort | uniq -c | sed -e '/^ *1 /d' | sort -nr
br

# Prepare to loop through the set of all reachable filenames (commands) sorted by
# filename.  Report all the duplicate paths for each filename.
#
# Initialize state variables to unmatchable values.
# This will let us smoothly enter the "read nextine" loop below with coherent state.
# The state variables are
#    1 == "previous", 2 == "current", 3 == "next" for filenames and paths
file1="dummy 1 /previous"; path1=""
file2="dummy 2 /current";  path2=""
file3="dummy 3 /next";     path3=""

echo "Pathnames of the duplicate filenames"
pathfiles |
while read fullpath
do
  # Emit "basename|fullpath". The "|" is a delimiter not in filenames.
  [[ $fullpath =~ /([^/]*)$ ]]
  echo ${BASH_REMATCH[1]}'|'$fullpath
done |
sort |  # by basename, with fullpath attached
( cat ; echo "dummy last|none" ) |  # append a dummy to end of sorted stream for smooth finish
while read nextline  # the new next "filename|fullpath"
 do
   # Enter here with "filename|fullpath" records sorted by ascending filename
   # Split the sorted record on '|' back into filename and fullpath
   [[ $nextline =~ ^([^|]*)\|(.*)$ ]]
   # file3 and path3 hold the "next" valuses
   file3=${BASH_REMATCH[1]}
   path3=${BASH_REMATCH[2]}

   # Emit the full path for "current" file2 if it  matches
   # either the previous or the next file (or both)
   [[ ("$file2" == "$file1") || ("$file2" == "$file3") ]] && echo $path2

   # Move current to previous and next to current
   file1=$file2; # path1=$path2
   file2=$file3; path2=$path3
 done 
 # Exit the while loop with no more "next". The old "current" was processed

