#!/bin/bash
#
# Help figure out PATH settings
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
pathfiles | sed -e 's=^.*/==' | sort | uniq -c | sed -e '/^ *1 /d' | sort -n
br

# 1 == "previous", 2 == "current", 3 == "next"
# Initialize everything to unmatchable values so we can start reading "next"
cmd1="dummy 1";path1=""
cmd2="dummy 2";path2=""
cmd3="dummy 3";path3=""

echo "Duplicate definitions in PATH"
pathfiles |
while read fullpath
do
  echo `basename $fullpath` $fullpath
done |
sort |  # by basename
while read cmd3 path3  # read the new "next" command and full path
 do

   # Emit the current line if it's cmd matches either the previous or the next (or both)
   if [[ ( "$cmd2" == "$cmd1" ) || ( "$cmd2" == "$cmd3" ) ]]
   then
     echo $path2
   fi

   # Move current to previous and new next to current for next loop
   cmd1=$cmd2; path1=$path2
   cmd2=$cmd3; path2=$path3

 done 
 # Exiting the while loop with no "next". The old "current" was processed

