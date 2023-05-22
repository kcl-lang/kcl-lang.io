#!/bin/sh

# Stop on error.
set -e

pwd=$(cd `dirname $0`; pwd)

# Configuration example tests
cd $pwd/configuration && make test && cd $pwd
# Validation example tests
cd $pwd/validation && make test && cd $pwd
# Abstraction example tests
cd $pwd/abstraction && make test && cd $pwd
# Definition example tests
cd $pwd/definition && make test && cd $pwd
# Mutation example tests
cd $pwd/mutation && make test && cd $pwd
