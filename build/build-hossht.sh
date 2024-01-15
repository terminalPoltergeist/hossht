#!/usr/bin/env bash
### Build file for hossht ###

# Function definitions

error() {
  # courtesy https://stackoverflow.com/a/185900
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}

get_version() {
  v=$(git describe --tags --abbrev=0 || git describe --abbrev=0)
  [ $? -eq 0 ] && echo $v  || return 1
}

# Arg parsing

if [[ $# -eq 0 ]]; then
  help
  exit
fi

while [[ $OPTIND -le "$#" ]]; do
  if getopts ":t:" option; then
    case $option in
    t)
      types=("major" "minor" "patch")
      if [[ $(echo "${types[*]}" | grep -wi "${OPTARG}") ]]; then
        build_type=$OPTARG
      else
        error $(( $LINENO-3 )) "invalid build type. specify ('major', 'minor', or 'patch')" 2
      fi
    ;;
    \?)
      echo "ERROR: Invalid option: -$OPTARG"
      exit 1
    ;;
    esac
  else
    echo "positional arguments not supported: ${!OPTIND}"
    exit 2
  fi
done
