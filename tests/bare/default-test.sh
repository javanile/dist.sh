#!/usr/bin/env bash

cd "$(dirname "$0")/../fixtures/default"
rm -fr tmp && true

ls -Rla

../../../dist.sh

unzip -l default.zip