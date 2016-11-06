#!/usr/bin/env bash

lang1=$2
lang2="en"

get-subs () {
  subliminal download -l $1 ${name// /.}
}

# get magnet name
pirate-get -s SeedersDsc -0 -M $1
magnet=$(find . -maxdepth 1 -name "*.magnet" | head -1)
name=${magnet:2:-7}

# get subtitles
get-subs $lang1
sub=$(find . -maxdepth 1 -name "*.srt" | head -1)

# try to search in english if portuguese not found
if [ -z "$sub" ]; then
  get-subs $lang2
  sub=$(find . -maxdepth 1 -name "*.srt" | head -1)
fi

# remove parenthesis from subtitles filename
sub2=$(echo "$sub" | sed -re 's/[()]//g')
sub3=${sub2:2}
mv ${sub:2} ${sub3}

# get magnet to stream
pirate-get -s SeedersDsc -0 -C "peerflix \"%s\" -k -t ${sub3}" $1

# remove created files
rm *.srt && rm *.magnet
