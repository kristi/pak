#!/bin/bash

arch="x86_64"

# Download build files using rsync
SYNCSERVER="rsync.archlinux.org"
SYNCARGS='-mrtv --no-motd --delete-after --no-p --no-o --no-g'

base_dir=$PWD
mkdir -p "$base_dir/pkg"

MAKEPKG="$base_dir/bin/makepkg --config $base_dir/makepkg.conf"

# Build libarchive dependencies
for package in bzip2 #zlib openssl bzip2 
do
    cd "$base_dir/pkg"
    rsync $SYNCARGS "$SYNCSERVER::abs/$arch/core/$package" .

    cd "$package"
    $MAKEPKG -f
done

# AUR packages
for package in patchelf 
do
    cd "$base_dir/pkg"
    curl "http://aur.archlinux.org/packages/${package:0:2}/$package/$package.tar.gz" | tar -zx

    cd "$package"
    $MAKEPKG -f
done


#libarchive pacman
