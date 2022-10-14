#!/bin/bash

loop=1
while [[ $loop == 1 ]]; do
  read -e -p "Decrypt a volume [Y/n] " decrypt
  decrypt="$(echo ${decrypt:=y} | tr '[A-Z]' '[a-z]')"
  if [[ $decrypt == y ]]; then
    decrypt=1
    loop=0
  elif [[ $decrypt == n ]]; then
    decrypt=0
    loop=0
  else
    echo "${decrypt} is not a valid parameter"
  fi
done

UNLOCKED_VOLUME_PATH="/media"

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

function valid_filename {
  local filename="$1"
  if [[ $filename == "" ]]; then
     return 1
  fi

  if [[ $filename == "." ]] || [[ $filename == ".." ]]; then
      # "." and ".." are added automatically and always exist, so you can't have a
      # file named . or .. // https://askubuntu.com/a/416508/660555
      return 1
  fi

  if [[ $val -gt 255 ]]; then
     # String's length check
      return 1
  fi

  if ! [[ $filename =~ ^[0-9a-zA-Z._-]+$ ]]; then
      # Checks whether valid characters exist
      return 1
  fi

  _filename=$(echo $filename | cut -c1-1)
  if ! [[ $_filename =~ ^[0-9a-zA-Z.]+$ ]]; then
      # Checks the first character
      return 1
  fi
  return 0
}

if [[ $decrypt == 1 ]]; then
  echo -e "\n`ls -l --all`\n"
  loop=1
  while [[ $loop == 1 ]]; do
    read -e -p "Choose the path of the file to decrypt: " file_path
    if [[ -f $file_path ]]; then
      loop=0
    else
      echo -e "Unvalid name\n"
    fi
  done

  loop=1
  while [[ $loop == 1 ]]; do
    read -e -p "Choose an alias for the unlocked volume: " alias
    if ! `valid_filename $alias`; then
      echo -e "Unvalid name\n"
      continue
    fi
    loop=0
    for f in *
    do
      if `exists "${UNLOCKED_VOLUME_PATH}/${alias}" e`; then
        echo -e "Name already used\n"
        loop=1
        break
      fi
    done
  done

  while [[ true ]]; do
    sudo cryptsetup open --type tcrypt $file_path $alias
    decrypted=$?
    if [[ $decrypted == 0 ]]; then
      break
    else
      error_msg="\nAuthentication failed"
      case "$decrypted" in
        1) error_msg="${error_msg}: wrong parameters"
        ;;
        2) error_msg="${error_msg}: no permission (bad passphrase)"
        ;;
        3) error_msg="${error_msg}: out of memory"
        ;;
        4) error_msg="${error_msg}: wrong device specified"
        ;;
        5) error_msg="${error_msg}: device already exists or device is busy"
      esac
      echo -e $error_msg
    fi
  done
  sudo mkdir "${UNLOCKED_VOLUME_PATH}/${alias}"
  sudo mount -o uid=1000 "/dev/mapper/${alias}" "${UNLOCKED_VOLUME_PATH}/${alias}"
  echo -e "\nDevice successfuly mounted"
fi

if [[ $decrypt == 0 ]]; then
  echo -e "\n`ls -l --all ${UNLOCKED_VOLUME_PATH}`\n"
  loop=1
  while [[ $loop == 1 ]]; do
    read -e -p "Choose the volume to close: " alias
    if [[ -d "${UNLOCKED_VOLUME_PATH}/${alias}" ]]; then
      loop=0
    else
      echo -e "Unvalid name\n"
    fi
  done
  sudo umount "${UNLOCKED_VOLUME_PATH}/${alias}"
  deleted=$?
  if [[ $deleted != 0 ]]; then
    echo "Unexpected behavior: couldn't unmount '${UNLOCKED_VOLUME_PATH}/${alias}'"
    exit 1
  fi
  sudo cryptsetup close $alias
  closed=$?
  if [[ $closed != 0 ]]; then
    echo "Unexpected behavior: couldn't close '/dev/mapper/${alias}'"
    exit 1
  fi
  if [[ -z "$(ls -A ${UNLOCKED_VOLUME_PATH}/${alias})" ]]; then
    sudo rm -r ${UNLOCKED_VOLUME_PATH}/${alias}
  else
    echo "Unexpected behavior: couldn't delete '${UNLOCKED_VOLUME_PATH}/${alias}"
    exit 1
  fi
  echo -e "\nDevice successfuly unmounted"
fi
