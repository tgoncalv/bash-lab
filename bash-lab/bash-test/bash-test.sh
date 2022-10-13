#!/bin/bash

folder_name=$1

if [[ ${folder_name} == '' ]]; then
  echo "No folder name provided. The default name 'test_bash' would be used."
  folder_name='test_bash'
fi

if [[ -e $folder_name ]]; then
  echo "The folder '${folder_name}' already exists."
  exit;
fi

mkdir $folder_name

init_file_name="init.sh"
end_file_name="end.sh"
init_file="${folder_name}/${init_file_name}"
end_file="${folder_name}/${end_file_name}"

cat "${0%/*}/bash-test/default-test-init-sh.txt" >> $init_file
cat "${0%/*}/bash-test/default-test-end-sh.txt" >> $end_file

chmod +x $init_file
chmod +x $end_file

`cd $folder_name; ./$init_file_name`
