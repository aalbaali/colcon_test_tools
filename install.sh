#!/bin/bash

# Copy installation file to installation directory
cp colcon_tools.sh /usr/local/bin

# Installation script sources `run_tests` into `.bashrc`, if `.bashrc` doesn't do that already
if [ -n $(cat ~/.bashrc | grep "colcon_tools.sh") ]
then
  echo "source /usr/local/bin/colcon_tools.sh" >> ~/.bashrc
fi