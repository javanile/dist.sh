#!/usr/bin/env bash
set -e

current_pwd=$(pwd)

#cd "$(dirname "$0")/../fixtures/default" || exit 1
#rm -fr tmp && true
##ls -Rla

echo "====[ Test unknown option ]========================================================"
cd "$(dirname "$0")/../fixtures/default" || exit 1
../../../dist.sh --unknown-option || true
cd "${current_pwd}"
echo

echo "====[ Test missing .distfile ]====================================================="
cd "$(dirname "$0")/../fixtures" || exit 1
../../dist.sh || true
cd "${current_pwd}"
echo
