[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# In this repo
This repository provides a tool to run unit tests for built custom colcon packages.


# Usage
The `colcon_tools.sh` provides the `colcon_test` function, which runs the unit tests.

## Running all tests for all packages
To run all tests, execute
```bash
colcon_test
```
## Running all tests for a specific package
To run all tests for a colcon package `<package-name>`, run
```bash
colcon_test <package-name>
```
Note that [autocompletion is available](#tab-auto-completion).

## Running specific tests for a specific package
To run tests for a given package, run
```bash
colcon_test <package-name> <test-name-1> <test-name-2> <...>
```
where `<package-name>` is the colcon package name and `<test-name>` is the test name for the given package.
The function can take arbitrarily multiple test arguments.
Note that [autocompletion is available](#tab-auto-completion) for both package names and test names.

## Tab auto-completion
Note that auto-completion is provided for packages *with executable tests*.
That is, if a package doesn't have an executable test, or the package is not built yet, then it will not be autocompleted.

# Setup
## Installation
- Install script by running
```bash
./install.sh
```
Note, this may require elevated permissions (i.e., `sudo`)

## Uninstall
To uninstall, remove `/usr/local/bin/colcon_tools.sh` and clear the `source /usr/local/bin/colcon_tools.sh` from `~/.bashrc`.
