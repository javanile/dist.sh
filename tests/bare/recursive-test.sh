#!/usr/bin/env bash

cd "$(dirname "$0")/../fixtures/recursive" || exit 1
rm -fr tmp && true

#ls -Rla

echo "====[ Recursive test ]========================================================"
../../../dist.sh --debug
echo

echo "---"
unzip -l sample.zip
