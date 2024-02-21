#!/usr/bin/env bash

##
# DIST.SH
#
# The best way to zip your source code.
#
# Copyright (c) 2020 Francesco Bianco <bianco@javanile.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##

[[ -z "${LCOV_DEBUG}" ]] || set -x

set -ef

cwd=${PWD}

VERSION="0.1.0"

failure() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
}
#trap 'failure "${LINENO}" "$BASH_COMMAND"' 0

##
#
##
error () {
    echo "[dist.sh] $1"
    exit 1
}

##
#
##
scope () {
    base=
    dist=${1:-$(basename "${cwd}").zip}
    tmp="${cwd}$(mktemp -d -t dist-XXXXXXXXXX)"
    mkdir -p "${tmp}"
    touch "${tmp}/.dist_include"
    touch "${tmp}/.dist_exclude"
}

##
#
##
build () {
    cd "${tmp}"
    echo -n "[dist.sh] File created: '${dist}', size="
    rm -f "${cwd}/${dist}"
    zip -qq -r "${cwd}/${dist}" ./ -i "@.dist_include" -x "@.dist_exclude"
    stat -c %s "${cwd}/${dist}" | numfmt --to=iec
    rm -rf "${tmp}"
    cd "${cwd}"
}

##
#
##
copy () {
    mkdir -p $2
    file=$(mktemp -t dist-clone-XXXXXXXXXX).zip
    zip -qq -r ${file} . -i $1
    unzip -qq -o ${file} -d $2 > /dev/null 2>&1 && true
    rm -f ${file}
}

parse() {
  local mode

  mode=$1

  scope

      init=
      while IFS= read line || [[ -n "${line}" ]]; do
          case "${line::1}" in
              "#"|"")
                  continue
                  ;;
              "&")
                  cd ${tmp}/${base}
                  eval ${line:1}
                  cd ${cwd}
                  continue
                  ;;
              "@")
                  [[ -z "${init}" ]] || build
                  scope "$(echo ${line:1} | envsubst)"
                  ;;
              ">")
                  base="$(echo ${line:1} | envsubst)/"
                  ;;
              "!")
                  line="$(echo ${line:1} | envsubst)"
                  [[ -z "${line}" ]] && continue
                  [[ -d "${line}" ]] && fix="/*" || fix=
                  echo ${base}${line}${fix} >> ${tmp}/.dist_exclude
                  ;;
              "+")
                  line="$(echo ${line:1} | envsubst)"
                  [[ -z "${line}" ]] && continue
                  [[ -d "${line}" ]] && fix="/*" || fix=
                  echo ${base}${line}${fix} >> ${tmp}/.dist_include
                  ;;
              *)
                  line="$(echo ${line} | envsubst)"
                  [[ -z "${line}" ]] && continue
                  [[ -d "${line}" ]] && fix="/*" || fix=
                  copy ${line}${fix} ${tmp}/${base}
                  echo ${base}${line}${fix} >> ${tmp}/.dist_include
                  ;;
          esac
          init=true
      done < .distfile

      build
}


##
#
##
main () {
  if [[ ! -e .distfile ]]; then
    error "Missing '.distfile' in '${cwd}'."
  fi

  parse build "${cwd}/.distfile"
}

main
