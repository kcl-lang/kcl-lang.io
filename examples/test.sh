#!/bin/sh

# Stop on error.

# Note: Before you start tests, please install kcl and kpm

set -e

pwd=$(
    cd $(dirname $0)
    pwd
)

for path in "configuration" "validation" "abstraction" "definition" "mutation" "data-integration" "automation", "package-management"; do
    echo "\033[1mTesting $path ...\033[0m"
    if (cd $pwd/$path && make test); then
        echo "\033[32mTest SUCCESSED - $path\033[0m\n"
    else
        echo "\033[31mTest FAILED - $path\033[0m\n"
    fi
done
