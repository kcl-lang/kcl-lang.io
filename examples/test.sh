#!/bin/sh

# Stop on error.
set -e

pwd=$(cd `dirname $0`/; pwd)

# Configuration example tests
cd $pwd/configuration && make test && cd $pwd
