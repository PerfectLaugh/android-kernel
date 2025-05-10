#!/bin/sh

BASEDIR=$(dirname "$0")
cd aosp || exit

curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s main

cd KernelSU || exit
KERNELSU_REV_HEAD=$(git rev-list --count HEAD)
KERNELSU_REV_HEAD=$((10000 + 200 + KERNELSU_REV_HEAD))
sed -i "s/ccflags-y += -DKSU_VERSION=[0-9]*/ccflags-y += -DKSU_VERSION=$KERNELSU_REV_HEAD/" ./kernel/Makefile
git add -A && git commit -m "replace KernelSU version"
cd ..

rm ./android/abi_gki_protected_exports_*
sed -i "s/\"\[uprobes\]\"/\"\[u\.probes\]\"/" kernel/events/uprobes.c
git add -A && git commit -m "customizations"

git apply "../$BASEDIR/jit-cache.patch"
git add -A && git commit -m "remove jit-cache maps"
