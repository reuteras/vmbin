#!/bin/bash

[[ ! -d "${HOME}/shares" ]] && mkdir "${HOME}/shares"

sudo /usr/bin/vmhgfs-fuse .host:/ "${HOME}/shares" -o subtype=vmhgfs-fuse,allow_other
