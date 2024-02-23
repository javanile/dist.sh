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
debug_mode=
default_dist="$(basename "${cwd}").zip"

VERSION="0.2.0"

##
#
##
usage() {
  echo "Usage: ./dist.sh [OPTION]..."
  echo ""
  echo "Create package files (ZIP at moment) as defined into .distfile"
  echo ""
  echo "List of available options"
  echo "  -d, --debug         Show debug information"
  echo "  -h, --help          Display this help and exit"
  echo "  -v, --version       Display current version"
  echo ""
  echo "Documentation can be found at https://github.com/javanile/dist.sh"
}

##
#
##
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
  echo "$1" >&2
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
  echo "*/.distfile" > "${tmp}/.dist_exclude"
  if [ -n "${debug_mode}" ]; then
    echo
    echo "| ${dist} |"
  fi
}

##
#
##
build () {
  local dist_dir

  cd "${tmp}"
  dist_dir=$(dirname "${cwd}/${dist}")
  [ -d "${dist_dir}" ] || mkdir -p "${dist_dir}" && true >/dev/null 2>&1
  rm -f "${cwd}/${dist}"
  zip -qq -r "${cwd}/${dist}" ./ -i "@.dist_include" -x "@.dist_exclude"
  echo -n "Package was created: '${dist}', size="
  stat -c %s "${cwd}/${dist}" | numfmt --to=iec
  [ -z "${debug_mode}" ] && rm -rf "${tmp}"
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
  if [ -n "${debug_mode}" ]; then
    echo "$1" >&2
  fi
}

##
#
##
parse() {
  local mode
  local distfile
  local import

  local line
  local char
  local data

  local init
  local pass

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
      if [ -n "${init}" ]; then
        [ "${mode}" = "build" ] && build
      else
        debug "Default package '${dist}' was skipped."
      fi
      if [ "${mode}" = "build" ]; then
        scope "${data}"
        continue
      elif [ "${dist}" = "${data}" ]; then
        pass=
        continue
      else
        pass=true
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
        debug "| ${dist} | ${distfile} | ${base} | ${line}"
        base="${data}/"
        ;;
      "!")
        debug "| ${dist} | ${distfile} | ${base} | ${line}"
        [ -d "${data}" ] && fix="/*" || fix=
        echo "${base}${import}${data}${fix}" >> "${tmp}/.dist_exclude"
        ;;
      "+")
        debug "| ${dist} | ${distfile} | ${base} | ${line}"
        [ -d "${data}" ] && fix="/*" || fix=
        echo "${base}${data}${fix}" >> "${tmp}/.dist_include"
        ;;
      *)
        debug "| ${dist} | ${distfile} | ${base} |  ${line}"
        [ -e "${import}${line}" ] || error "Resource not found: '${line}' claimed by '${distfile}'."
        [ -d "${line}" ] && fix="/*" || fix=
        copy "${line}${fix}" "${tmp}/${import}${base}"
        echo "${import}${base}${line}${fix}" >> "${tmp}/.dist_include"
        if [ -f "${import}${line}/.distfile" ]; then
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
  while true; do
    case "$1" in
      -d|--debug) debug_mode=1; ;;
      -v|--version) echo "dist.sh - by Francesco Bianco <bianco@javanile.org>"; exit ;;
      -h|--help) usage; exit ;;
      --) shift; break ;;
      "") break ;;
      *) error "Syntax error: unknown option '$1'"; ;;
    esac
    shift
  done

  if [[ ! -e .distfile ]]; then
    error "File not found: looking for '.distfile' on '${cwd}'."
  fi

  parse build .distfile
}

main "$@"
