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

[ -z "${LCOV_DEBUG}" ] || set -x

set -ef

cwd=${PWD}
debug_mode=0
default_dist="$(basename "${cwd}").zip"

VERSION="0.2.0"

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
scope() {
  base=
  dist=${1:-${default_dist}}
  name=$(basename "${dist}" .zip)
  date=$(date +%Y%m%d%H%M%S)
  tmp="${cwd}$(mktemp -d -t "dist-${name}-${date}-XXXXXXXXXX")"
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
  #rm -rf "${tmp}"
  cd "${cwd}" && true
}

##
#
##
copy () {
  mkdir -p "$2"
  file=$(mktemp -t dist-clone-XXXXXXXXXX).zip
  zip -qq -r "${file}" . -i "$1"
  unzip -qq -o "${file}" -d "$2" > /dev/null 2>&1 && true
  rm -f "${file}"
}

##
#
##
debug () {
  echo "$1" >&2
}

##
#
##
parse() {
  local mode
  local distfile
  local import

  local char
  local line
  local init
  local pack
  local fix

  mode=$1
  distfile=$2
  import=$3
  pass=
  init=

  case "${mode}" in
    "build")
      scope
      ;;
    "import")
      init=true
      [ "${dist}" != "${default_dist}" ] && pass=true
      #echo "Import: $distfile ($import)"
      ;;
  esac

  while IFS= read -r line || [ -n "${line}" ]; do
    char="${line::1}"
    data="$(echo "${line:1}" | envsubst)"

    [ -z "${data}" ] && continue

    if [ "${char}" = "@" ]; then
      [ -z "${init}" ] || build
      if [ "${mode}" = "build" ]; then
        scope "${data}"
        continue
      elif [ "${dist}" != "${data}" ]; then
        pass=true
      else
        pass=
      fi
    fi

    [ -n "${pass}" ] && continue

    case "${char}" in
      "#"|"")
        continue
        ;;
      "&")
        cd "${tmp}/${base}${import}"
        eval "${data}"
        cd "${cwd}"
        continue
        ;;
      ">")
        base="${data}/"
        ;;
      "!")
        debug "> ${dist} > ${distfile} > ${line}"
        [ -d "${data}" ] && fix="/*" || fix=
        echo "${base}${import}${data}${fix}" >> "${tmp}/.dist_exclude"
        ;;
      "+")
        debug "> ${dist} > ${distfile} > ${line}"
        [ -d "${data}" ] && fix="/*" || fix=
        echo "${base}${data}${fix}" >> "${tmp}/.dist_include"
        ;;
      *)
        debug "> ${dist} > ${distfile} > ${line}"
        [ -d "${line}" ] && fix="/*" || fix=
        copy "${line}${fix}" "${tmp}/${base}"
        echo "${base}${import}${line}${fix}" >> "${tmp}/.dist_include"
        if [ -f "${import}${line}/.distfile" ]; then
          echo "${base}${import}${line}/.distfile" >> "${tmp}/.dist_exclude"
          parse import "${import}${line}/.distfile" "${import}${line}/"
        fi
        ;;
    esac
    init=true
  done < "${distfile}"

  if [ "${mode}" = "build" ]; then
    build
  fi
}


##
#
##
main () {
  if [[ ! -e .distfile ]]; then
    error "Missing '.distfile' in '${cwd}'."
  fi

  parse build .distfile
}

main
