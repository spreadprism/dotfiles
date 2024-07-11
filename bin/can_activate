#!/bin/zsh

# We can't activate if we are already in an environment
if [ ! -z "$CONDA_DEFAULT_ENV" ]; then
  if [ "$CONDA_DEFAULT_ENV" != "base" ]; then
    exit 1
  fi
fi

env_dir=$HOME/miniconda3/envs/
current_directory_name="${PWD##*/}"

if [ -d "$env_dir/$current_directory_name"_env ]; then
  exit 0
elif [ -d "$env_dir/$current_directory_name" ]; then
  exit 0
fi

exit 1
