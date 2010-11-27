#!/bin/bash
#
# Help figure out PATH settings
#
br() {
  echo "-----"
}
echo $PATH
br
echo $PATH | tr : '\n'
br
