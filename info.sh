#!/bin/bash

set -v # show current command

pwd
cat /proc/cpuinfo
df -h

systeminfo

export

echo "Show info done!"
