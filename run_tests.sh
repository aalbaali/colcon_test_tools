
# List custom colcon packages. Note that packages installed through ros-<distro>-<package-name> are
# not captured in this list
__list_colcon_pkgs() {
  colcon_cd && colcon list | awk '{print $1}'
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
colcon_test() {
  local tests="$(__list_tests_full_path $1 | rg $2\$)"
  if [ -n "$tests" ]
  then
    for test in $tests
    do
      echo -e "\033[36mTest: \033[96;1m$test\033[0m"
      $test
    done
  else
    echo -e "\033[91mProvided package \033[93;1m'$1'\033[0;91m and/or test \033[93;1m'$2'\033[0;91m are not valid"
    echo -e "\n\033[93mUse tab autocompletion to list \033[3mexecutable\033[0;93m packages and tests\033[0m"
  fi
  # echo "$(__list_tests_full_path $1 | $2$)"
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

usage() {
  echo "Usage not specified yet"
}


# List test given
#   $1: package name
#   $2: test name
find_tests () {
  echo -e "\nin 'find_tests'"
  echo "\$0: $0"
  echo \$1: $1
  echo \$2: $2
  echo 
  find $_colcon_cd_root/build/ -type f -executable | rg "$1(/.*)?/test/(.*/)?$2\$"
}

# Print list of callable functions within this script
__list_of_script_funcs() {
  declare -F | awk '{print $3}' | rg '^[^__]' --color never
}

# Add the bash autocomplete commands
# When running a script, call `source run_tests.sh __add_complete_commands`
__add_complete_commands() {
  complete -W '$(./run_tests.sh __list_of_script_funcs)' ./run_tests.sh
}


"$@"
# echo \$0: $0
# echo \$1: $1
# echo \$2: $2
# echo \$3: $3
# echo \$4: $4
# echo \$5: $5

# Default colcon workspace build-path is assumed to be relative to the workspace directory
COLCON_BUILD_PATH="build/"

# Get options
while getopts "b:" opt; do
  case $opt in
    b ) COLCON_BUILD_PATH=$OPTARG;;

    * ) usage
        exit 0;;
  esac
done


# _list_of_funcs
# declare -F
# echo "build_path: ${COLCON_BUILD_PATH}"
# find_tests $1 $2
