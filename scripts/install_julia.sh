#!/bin/bash
set -e

## build ARGs
NCPUS=${NCPUS:--1}

#JULIA_VERSION=${1:-${JULIA_VERSION:-latest}}

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

ARCH_LONG=$(uname -p)
ARCH_SHORT=$ARCH_LONG

if [ "$ARCH_LONG" = "x86_64" ]; then
    ARCH_SHORT="x64"
fi

apt_install wget ca-certificates


# Download Julia and create a symbolic link.
wget "https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.3-linux-x86_64.tar.gz"
mkdir /opt/julia
tar zxvf "julia-1.7.3-linux-x86_64.tar.gz" -C /opt/julia --strip-components 1
rm -f "julia-1.7.3-linux-x86_64.tar.gz"
ln -s /opt/julia/bin/julia /usr/local/bin/julia

julia --version

# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages

## Strip binary installed lybraries from RSPM
## https://github.com/rocker-org/rocker-versioned2/issues/340
strip /usr/local/lib/R/site-library/*/libs/*.so

