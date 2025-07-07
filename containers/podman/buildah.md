```sh
# create an empty container with [scratch]
newcontainer=$(buildah from scratch)
buildah containers
buildah images
# mount [scratch] container
export newcontainer
buildah unshare
scratchmnt=$(buildah mount $newcontainer)
echo $scratchmnt
# install packages to [scratch] container
dnf -y group install "Minimal Install" --releasever=9 --installroot=$scratchmnt
# unmount
buildah umount $newcontainer
# run container
buildah run $newcontainer bash
cat /etc/os-release
exit
# add images
buildah commit $newcontainer rl:9.6
buildah images

```
