#!/usr/bin/env bash

cd "$(dirname "$0")/../fixtures/recursive"
rm -fr tmp && true

ls -Rla

../../../dist.sh

unzip -l recursive.zip
