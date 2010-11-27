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
echo $PATH
br
aslines
br
echo '#Bytes'	"	" "In path"
du -hs `aslines`
br
  echo '#Files'	"	" "In path"
for f in `aslines`
do
  echo $(find $f | wc -l) "	" $f
done
br

