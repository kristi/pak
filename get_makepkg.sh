#!/bin/bash
#
# Get the makepkg script from the archlinux repo
#
# Since makepkg is just a bash script, we can just extract the file
#

arch="x86_64"
mirror="http://mirrors.kernel.org/archlinux"
repo="core"

# get latest pacman version
db_uri="$mirror/$repo/os/$arch/$repo.db"
[[ -e "$repo.db" ]] || wget "$db_uri"
pacman_dir=$(tar --exclude="*/*" -ztf "$repo.db" | grep "^pacman-[0-9][0-9.]*-[0-9]*")
#curl -sS "$db_uri" | tar --exclude="*/*" -zt | grep "^pacman-[0-9][0-9.]*-[0-9]*"

## Get a list of file names
#tar --exclude="*/depends" -O -xf core.db | sed -n '/^%NAME%$/{n;p}'

# Download pacman package
package=${pacman_dir/\//-$arch.pkg.tar.xz}
package_uri="$mirror/$repo/os/$arch/$package"
[[ -e "$package" ]] || wget "$package_uri"

# Extract makepkg
tar --strip-components=1 -xf "$package" "usr/bin/makepkg" "etc/makepkg.conf"

# Disable fakeroot
sed -i -e '/^BUILDENV/ s/fakeroot/!fakeroot/' makepkg.conf
# Use tar instead of bsdtar
patch -p0 bin/makepkg < makepkg.tar.patch

