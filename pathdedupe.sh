#/bin/bash
#
# Emit a deduped version of $PATH, with order preserved
#
echo $PATH | tr ':' '\n' | # elements to individual lines
cat -n | sort -u -k 2 | # number lines, sort by path, keep unique
sort -n | sed -e 's/^.......//' | # to original order, remove numbers
tr '\n' ':' # back to ':' separated elements
