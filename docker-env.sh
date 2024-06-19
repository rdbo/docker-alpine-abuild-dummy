#!/bin/sh

set -e

docker build -t abuild-dummy .
docker run -v "$(pwd)/aports:/aports" -it abuild-dummy sh
