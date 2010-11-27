#!/bin/bash
#
# Help figure out PATH settings
#
br() {
  echo "-----"
}
aslines() {
  echo $PATH | tr : '\n'
}
livepaths() {
for f in `aslines`
do
  [[ -d $f ]] && echo $f
done
}

echo 'echo $PATH'
echo '----------'
echo $PATH
br

echo "On separate lines (" $( aslines | wc -l ) "entries ):"
aslines
br

echo "Issues: "
for f in `aslines`
do
  [[ ! -d $f ]] && echo "Not a directory, ignore: " $f
done
br

echo '#Bytes'	"	" "In path"
du -hs `livepaths`
br

  echo '#Files'	"	" "In path"
for f in `livepaths`
do
  echo $(find $f | wc -l) "	" $f
done
br
echo "Duplicated in PATH"
find `livepaths` | sed -e 's=^.*/==' | sort | uniq -c | sed -e '/^ *1 /d' | sort -n
