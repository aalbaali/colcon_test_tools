
# List custom colcon packages. Note that packages installed through ros-<distro>-<package-name> are
# not captured in this list
__list_colcon_pkgs() {
  # colcon_cd && colcon list | awk '{print $1}'
  # cd -
  find $_colcon_cd_root/build -executable | \
  awk -F"/" '{for(i=1;i<=NF;i++){if ($i ~ /build/){print $(i+1)}}}' | awk '!a[$0]++' | awk 'NF'
}

# List of executable scripts with full path
#   $1: package name (exact name). If empty, then it's supposed to list all tests
__list_tests_full_path() {
  # Use `_colcon_cd_root` provided by colcon
  find $_colcon_cd_root/build/ -type f -executable | rg "$1(/.*)?/test/.*" --color never
}

# List tests for given packages stripped from the full path
# Arguments
#   $1: package name (exact name). If empty, then it's supposed to list all tests
__list_tests() {
  for test in $(__list_tests_full_path $1)
  do
    echo $test | awk -F / '{print $NF}'
  done
}

# Run a colcon test
#  $1: Package (exact) name
#  $2: Test name
# If no arguments are passed (i.e., both $1 and $2 are empty), then all tests are executed
# If first argument is passed but no second argument (i.e., a test) is passed, then all tests for
# the package are executed
colcon_test() {
  if [ -z $1 ]
  then
    echo -e "\033[93;1mRunning all tests\033[0m"
    echo -e "\n\033[93;1m-----------------\033[0m\n"
  elif [ -z $2 ]
  then
    echo -e "\033[93mRunning all tests for \033[1m'$1'\033[0;93m package\033[0m"
    echo -e "\n\033[93;1m-----------------\033[0m\n"
  fi

  local tests="$(__list_tests_full_path $1 | rg $2\$)"
  if [ -n "$tests" ]
  then
    for test in $tests
    do
      echo -e "\033[36m-------------------------------\033[0m"
      echo -e "\033[36mTest: \033[96;1m$test\033[0m"
      echo -e "\033[36m-------------------------------\033[0m"
      $test
    done
  else
    echo -e "\033[91mProvided package \033[93;1m'$1'\033[0;91m and/or test \033[93;1m'$2'\033[0;91m are not valid"
    echo -e "\n\033[93mUse tab autocompletion to list \033[3mexecutable\033[0;93m packages and tests\033[0m"
  fi
}


# List of TESTABLE packages
#  Go over each package (including non testable ones) and call `__list_tests`. If it's not empty,
#  then print the package name
__list_of_testable_packages() {
  # List of all colcon packages
  local pkg_names=$(__list_colcon_pkgs)

  # List of all executable tests
  local all_tests=$(__list_tests)

  # Go over each colcon package and check if it has an executable test
  for pkg_name in $(__list_colcon_pkgs)
  do
    if [ -n "$(__list_tests $pkg_name)" ]
    then
      echo $pkg_name
    fi
  done
}

# Print list of callable functions within this script
__list_of_script_funcs() {
  declare -F | awk '{print $3}' | rg '^[^__]' --color never
}


# Helpful reference for writing completion scripts: https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial
# Add the bash autocomplete commands
# When running a script, call `source run_tests.sh __add_complete_commands`
__add_complete_commands() {
  # TODO: abort/warn if more than an argument is passed

  local cur prev

  local cmd="${1##*/}"
  local word=${COMP_WORDS[COMP_CWORD]}
  local line=${COMP_LINE}

  # Completion type (https://unix.stackexchange.com/questions/166908/is-there-anyway-to-get-compreply-to-be-output-as-a-vertical-list-of-words-instea)
  COMP_TYPE=63 # 63 for <tab><tab>, or 9 for <tab>
  COMP_KEY=63 # 63 for <tab><tab>, or 9 for <tab>

  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}

  if [ $COMP_CWORD -eq 1 ]; then
    # Print suggestions line by line
    suggestions=( $(compgen -W "$(__list_of_testable_packages)" -- $cur) )
    COMPREPLY=("${suggestions[@]}")
  fi
}

# Add auto-complete commands
complete -F __add_complete_commands colcon_test