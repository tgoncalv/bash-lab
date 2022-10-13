# bash-lab

Workspace containing all the bash scripts that I coded for my personal needs.

## How to learn bash

If you already know at least one programming language, I suggest you to learn bash scripting using [Code Learning Dojo](https://learn-bash.org/hello-world.html) which gives you the fundamental of bash language with some basic training exercises (This is the learning flow that I followed and that was pretty fast to be able start writing your first own scripts). After that, you could rely on internet  whenever you need to find a solution for any specific problems.

## My scripts

### [bash-test.sh](./bash-lab/bash-test/)

Creates a folder which can be used as a workspace where one can safely work on a new script. Concretely, the user runs `bash-test.sh (name of the folder)` to create a folder with a specific name (the default folder's name is `test-bash`). Inside this folder, the user has access to two files: `init.sh` and `end.sh` which respectively initializes and cleans the content of the test folder. `bash-test.sh` generates these two files using the templates `default-test-init-sh.txt` and `default-test-end-sh.txt`. It also automatically runs `init.sh` one time.
