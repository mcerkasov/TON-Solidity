#!/bin/bash

set -e

FILE_LIST_NAME=${1%.*} # filename without extension

# Check if tonos-cli installed 
tos=./tonos-cli
if $tos --version > /dev/null 2>&1; then
    echo "OK $tos installed locally."
else 
    tos=tonos-cli
    if $tos --version > /dev/null 2>&1; then
        echo "OK $tos installed globally."
    else 
        echo "$tos not found globally or in the current directory. Please install it and rerun script."
    fi
fi

function decode {
    tondev sol compile $FILE_LIST_NAME.sol
    $tos decode stateinit $FILE_LIST_NAME.tvc --tvc > $FILE_LIST_NAME.decode.json
}

echo "Creating a decode.json"
decode
sed -i "/Config/,/Decoded data/d" "$FILE_LIST_NAME.decode.json"