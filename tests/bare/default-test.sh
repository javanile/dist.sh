#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../fixtures/default" || exit 1
rm -fr tmp && true
#ls -Rla

echo "====[ Default test ]========================================================"
../../../dist.sh --debug
echo

echo "---"
unzip -l default.zip
