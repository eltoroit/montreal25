#!/bin/bash
echo "HELLO"
echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Total number of arguments: $#"
echo "All arguments: $@"
date
while getopts "a:b:" opt; do
  case $opt in
    a)
      a_value="$OPTARG"
      ;;
    b)
      b_value="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

echo "Value of a: $a_value"
echo "Value of b: $b_value"