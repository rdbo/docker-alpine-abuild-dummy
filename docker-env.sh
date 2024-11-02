#!/bin/sh

set -e

docker build -t abuild-dummy .
mkdir -p repo distfiles
docker run -v "$(pwd)/aports:/aports" -v "$(pwd)/repo:/repo" -v "$(pwd)/distfiles:/var/cache/distfiles" -it abuild-dummy sh
