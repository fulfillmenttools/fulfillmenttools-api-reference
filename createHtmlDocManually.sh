#!/bin/bash

command -v asciidoctor >/dev/null 2>&1 || { echo >&2 "asciidoctor is required to run this script, but it's not installed.  Aborting."; exit 1; }

asciidoctor ./doc/Readme.adoc -o index.html
