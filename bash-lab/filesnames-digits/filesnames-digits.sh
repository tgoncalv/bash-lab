#!/bin/bash

loop=1
while [[ $loop == 1 ]]; do
  read -e -p "Select filestype [0: all (default), 1: directories, 2: file] " filestype
  filestype="${filestype:=0}"
  if [[ $filestype == 0 ]]; then
    filestype='e'
    loop=0
  elif [[ $filestype == 1 ]]; then
    filestype='d'
    loop=0
  elif [[ $filestype == 2 ]]; then
    filestype='f'
    loop=0
  else
    echo "${filestype} is not a valid parameter"
  fi
done

loop=1
while [[ $loop == 1 ]]; do
  read -e -p "Standardize digits number [Y/n] " standardize
  standardize="$(echo ${standardize:=y} | tr '[A-Z]' '[a-z]')"
  if [[ $standardize == y ]]; then
    standardize=1
    loop=0
  elif [[ $standardize == n ]]; then
    standardize=0
    loop=0
  else
    echo "${standardize} is not a valid parameter"
  fi
done

function exists {
  local __file=$1
  local __filestypes=$2
    if ([ $__filestypes == e ] && [ -e $__file ]) || 
      ([ $__filestypes == d ] && [ -d $__file ]) || 
      ([ $__filestypes == f ] && [ -f $__file ]); then
    return 0
  fi
  return 1
}

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

DIGITS=(0 1 2 3 4 5 6 7 8 9)
are_digits() {
  local string=$1
  for ((i = 0; i < ${#string}; i++)); do
    if ! `is_in "${DIGITS[*]}" "${string:$i:1}"` ; then
      return 1
    fi
  done
  return 0
}

echo -e "\nThe following files would be modified: "
files=()
max_digits=0
for f in *
do
  underscore=`expr index "$f" '_' - 1`
  if `exists "${f}" "${filestype}"` && [ $underscore -gt 0 ] && `are_digits "${f::$underscore}"`; then
    echo " - ${f} (${underscore} digits)"
    files[${#files[@]}]=$f
    if [[ $underscore -gt max_digits ]]; then
      max_digits=$underscore
    fi
  fi
done

if [[ standardize == 1 ]]; then
  echo -e "\nAfter standardization, all these files would have ${max_digits} digits."
else
  echo -e "\nAll the unnecessary digits would be removed from these files."
fi

loop=1
while [[ $loop == 1 ]]; do
  read -e -p "Accept modification? [y/N] " accept
  accept="$(echo ${accept:=n} | tr '[A-Z]' '[a-z]')"
  if [[ ${accept} == y ]]; then
    loop=0
  elif [[ ${accept} == n ]]; then
    echo "Modification cancelled"
    exit
  else
    echo "${accept} is not a valid parameter"
  fi
done

for f in ${files[@]}
do
  underscore=`expr index "$f" '_' - 1`
  new_name="$f"
  case "$standardize" in
    1)
    while [[ $underscore -lt max_digits ]]; do
      new_name="0${new_name}"
      underscore=$(($underscore+1))
    done
    ;;
    0) 
    while [[ $underscore -gt 1 && ${new_name::1} == 0 ]]; do
      new_name="${new_name:1}"
      underscore=$(($underscore-1))
    done
    ;;
  esac
  if ! `exists $new_name "e"`; then
    mv $f $new_name
  elif [[ $f != $new_name ]]; then
    echo "${f} cannot be renamed to ${new_name} as this file already exists."
  fi
done
