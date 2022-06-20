#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

# Load installation parameters.
source $SCRIPT_DIR/install_params.sh

# Apply configuration.
# TODO: include arguments to only apply configuration.
cd $git_dir/audio && ./setup.sh --config --tribler
cd $git_dir && tribler/src/./tribler.sh > $git_dir/tribler/tribler.log
