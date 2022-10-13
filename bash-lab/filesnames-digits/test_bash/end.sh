#!/bin/bash

exceptions=("init.sh" "end.sh" "filesnames-digits.sh")
for args in $@
do
  exceptions[${#exceptions[@]}]=$args
done

function is_in {
  local list="$1"
  local item="$2"
  if [[ $list =~ (^|[[:space:]])"$item"($|[[:space:]]) ]] ; then
    # yes, list include item
    return 0
  else
    return 1
  fi
}

for f in *
do
  # echo $f
  if ! `is_in "${exceptions[*]}" "$f"`; then
    rm -r "${f}"
  fi
done
