#!/bin/sh

BASEDIR=$(dirname "$0")
cd aosp || exit

# KernelSU
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s 0b243c24ab6640ea1553c08066a2386456985a0d

# UProbes
sed -i "s/\"\[uprobes\]\"/\"\[u\.probes\]\"/" kernel/events/uprobes.c
git add kernel/events/uprobes.c && git commit -m "uprobes customizations"

# JIT Cache
git apply "../$BASEDIR/jit-cache.patch"
git add -A && git commit -m "remove jit-cache maps"

cd KernelSU || exit
KERNELSU_REV_HEAD=$(git rev-list --count HEAD)
KERNELSU_REV_HEAD=$((30000 + KERNELSU_REV_HEAD))
sed -i "s/^ccflags-y += -DKSU_VERSION=[0-9]*$/ccflags-y += -DKSU_VERSION=$KERNELSU_REV_HEAD/" kernel/Kbuild
git add -A && git commit -m "replace KernelSU version"
cd ..
git add -A && git commit -m "add KernelSU"

# SUSFS
patch -p1 <"../$BASEDIR/external/susfs4ksu/kernel_patches/50_add_susfs_in_gki-android14-6.1.patch"
cp "../$BASEDIR/external/susfs4ksu/kernel_patches/fs"/* fs/
cp "../$BASEDIR/external/susfs4ksu/kernel_patches/include/linux"/* include/linux/
cd KernelSU || exit
patch -p1 <"../../$BASEDIR/external/susfs4ksu/kernel_patches/KernelSU/10_enable_susfs_for_ksu.patch"
git add -A && git commit -m "add SUSFS"
cd ..
git add -A && git commit -m "add SUSFS"

# Remove GKI Protected Exports
rm android/abi_gki_protected_exports_*
git add android && git commit -m "remove gki protected exports"
