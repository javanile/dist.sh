#!/usr/bin/env bash

cd "$(dirname "$0")/../fixtures/default"

ls -Rla

../../../dist.sh

unzip -l default.zip
