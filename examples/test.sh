#!/bin/sh

# Stop on error.
set -e

pwd=$(cd `dirname $0`; pwd)

for path in "configuration" "validation" "abstraction" "definition" "mutation" "data-integration"
do
    echo "Testing $path ..."
    cd $pwd/$path && make test && cd $pwd
    echo "Test success - $path"
done
