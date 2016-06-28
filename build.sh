#!/bin/bash -e

ARCH=${ARCH:?"ARCH not set"}
SUFFIX=""
[ "${ARCH}" != "amd64" ] && SUFFIX="_${ARCH}"

git_version=$(git describe --tags)
if git_status=$(git status --porcelain 2>/dev/null) && [ -n "${git_status}" ]; then
  git_version="${git_version}-dirty"
fi

ldflags="-X github.com/vmware/govmomi/govc/version.gitVersion=${git_version} -linkmode external -extldflags -static -s"

go build -a \
  -o "govc_linux_${ARCH}" \
  -ldflags "${ldflags}" \
  github.com/vmware/govmomi/govc
