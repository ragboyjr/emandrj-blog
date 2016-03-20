#!/usr/bin/env bash

HUGO_VERSION="0.15"

if [[ `uname -s` == "Darwin" ]]; then
    os="darwin"
else
    echo "unsupported os: `uname -s`"
    exit
fi

if [[ `uname -m` == "x86_64" ]]; then
    arch="amd64"
else
    echo "unsupported arch: `uname -m`"
    exit
fi

name="hugo_${HUGO_VERSION}_${os}_${arch}"
url="https://github.com/spf13/hugo/releases/download/v$HUGO_VERSION/hugo_${HUGO_VERSION}_${os}_${arch}.zip"

mkdir tmp
pushd tmp
curl -L $url -o hugo.zip
unzip hugo.zip
cp $name/$name ../bin/hugo
popd
rm -rf tmp
