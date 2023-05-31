#!/bin/sh

# Stop on error.

# Note: Before you start tests, please install kcl and kpm

set -e

pwd=$(cd `dirname $0`; pwd)

for path in "configuration" "validation" "abstraction" "definition" "mutation" "data-integration" "automation", "package-management"
do
    echo "Testing $path ..."
    cd $pwd/$path && make test && cd $pwd
    echo "Test success - $path"
done
