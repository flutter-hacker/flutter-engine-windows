#!/bin/bash

set -v # show current command
set -x

function checkResult() {
    if [ $? -ne 0 ]; then
        echo "Last command failed, exit."
        exit $?
    fi
}

pwd

echo ${INPUT_FLUTTER_ENGINE_REVISION}
echo ${INPUT_GN_PARAMS}
echo ${INPUT_NINJA_PATH}

echo $@

echo $0
echo $1
echo $2

#ls -l  /c/Program\ Files\ \(x86\)/Windows\ Kits/
#ls -l  /c/Program\ Files\ \(x86\)/Windows\ Kits/10/

#find . -name "*.dll"
#find /c/Program\ Files\ \(x86\)/ -name dbgcore.dll

#ls -l /c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/Shared/Common/VSPerfCollectionTools/vs2022/dbgcore.dll
#ls -l /c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/Shared/Common/VSPerfCollectionTools/vs2022/x64/dbgcore.dll

#ls -l /c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/Shared/Common/VSPerfCollectionTools/vs2022/
#ls -l /c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/Shared/Common/VSPerfCollectionTools/vs2022/x64/

mkdir -p /c/Program\ Files\ \(x86\)/Windows\ Kits/10/Debuggers/

cp -r debugging_tools_dlls/10.0.19041.685/* /c/Program\ Files\ \(x86\)/Windows\ Kits/10/Debuggers/
checkResult

cd $HOME

pwd
cat /proc/cpuinfo
df -h

systeminfo

echo "Show info done!"


ls -l
cd $HOME
pwd
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ls -l
export PATH=`pwd`/depot_tools:$PATH
echo "`pwd`/depot_tools" >> $GITHUB_PATH

export
gclient

echo "Setup done!"


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

export DEPOT_TOOLS_WIN_TOOLCHAIN=0
set DEPOT_TOOLS_WIN_TOOLCHAIN=0

export GYP_MSVS_VERSION=2022
set GYP_MSVS_VERSION=2022

export GYP_MSVS_OVERRIDE_PATH="C:\\Program Files\\Microsoft Visual Studio\\2022\\Enterprise"
set GYP_MSVS_OVERRIDE_PATH="C:\\Program Files\\Microsoft Visual Studio\\2022\\Enterprise"

export

gclient sync -D -f
checkResult

df -h

echo "gclient sync finished!"

cd src/flutter
git status
git rev-parse HEAD
git rev-parse --short HEAD

tools/gn $INPUT_GN_PARAMS
checkResult

df -h

ninja -C $INPUT_NINJA_PATH
checkResult

df -h

echo "Build done!"
