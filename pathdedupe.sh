#/bin/bash
#
# Emit a $PATH copy removing duplicate entries, preserving order.
#
# Method: Split into individual lines, number the lines,
# sort by path keeping unique paths, sort back to original
# order, remove added line numbers, then back to path format
#
echo $PATH | tr ':' '\n' | cat -n |
sort -u -k 2 |
sort -n | sed -e 's/^.......//' |
tr '\n' ':' | sed -e 's/:$//'
