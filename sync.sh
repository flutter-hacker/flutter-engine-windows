#!/bin/bash

set -v # show current command

pwd
ls -l
cd $HOME

mkdir flutter_engine && cd flutter_engine
cat > .gclient << "EOF"
solutions = [
  {
    "managed": False,
    "name": "src/flutter",
    "url": "https://github.com/flutter/engine.git",
    "custom_deps": {},
    "deps_file": "DEPS",
    "safesync_url": "",
  },
]
EOF

set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set GYP_MSVS_VERSION=2022
set GYP_MSVS_OVERRIDE_PATH="C:\\Program Files\\Microsoft Visual Studio\\2022\\Enterprise"

export

gclient sync -D -f
df -h

echo "gclient sync finished!"
