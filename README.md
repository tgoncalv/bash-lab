# bash-lab

Workspace containing all the bash scripts that I coded for my personal needs.

## Table of contents

<!--toc:start-->
- [How to learn bash](#how-to-learn-bash)
- [My scripts](#my-scripts)
  - [bash-test](#bash-test)
  - [filesnames-digit](#filesnames-digit)
  - [autocrypt](#autocrypt)
<!--toc:end-->

## How to learn bash

If you already know at least one programming language, I suggest you to learn bash scripting using [Code Learning Dojo](https://learn-bash.org/hello-world.html) which gives you the fundamental of bash language with some basic training exercises (This is the learning flow that I followed and that was pretty fast to be able start writing your first own scripts). After that, you could rely on internet  whenever you need to find a solution for any specific problems.

## My scripts

### [bash-test](./bash-lab/bash-test/)

Creates a folder which can be used as a workspace where one can safely work on a new script. Concretely, the user runs `bash-test.sh (name of the folder)` to create a folder with a specific name (the default folder's name is `test-bash`). Inside this folder, the user has access to two files: `init.sh` and `end.sh` which respectively initializes and cleans the content of the test folder. `bash-test.sh` generates these two files using the templates `default-test-init-sh.txt` and `default-test-end-sh.txt`. It also automatically runs `init.sh` one time.

### [filesnames-digit](./bash-lab/filesnames-digits/)

Allows to rename files and folders which have the following name patterns:

- 00_filename
- 01_filename
- 101_filename

The script first asks to the user whether he wants to rename files, folders, or both. After that, the user can choose whether these files should have the same number of digits before the `_`, or if any unnecessary digits (the `0` digits) should be removed.

If the number of digits becomes standardized, the previous files would be renamed as the following:

- 0_filename
- 1_filename
- 101_filename

Otherwise, the files would be renamed like this:

- 000_filename
- 001_filename
- 101_filename

This script is useful as it helps ordering the files when displayed in the workspace. In fact `10` can sometimes be displayed before `2` because the sorting method would say that `1 < 2` without taking into account the number `10` as a single number.

### [autocrypt](./bash-lab/autocrypt/)

Allow encrypting/decrypting a disk using `tcrypt`.
