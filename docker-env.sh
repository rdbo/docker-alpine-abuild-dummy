#!/bin/sh

set -e

docker build -t abuild-dummy .
mkdir -p repo
docker run -v "$(pwd)/aports:/aports" -v "$(pwd)/repo:/repo" -it abuild-dummy sh
