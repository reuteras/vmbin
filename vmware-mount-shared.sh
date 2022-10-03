#!/bin/bash

sudo /usr/bin/vmhgfs-fuse .host:/ "${HOME}/shares" -o subtype=vmhgfs-fuse,allow_other
