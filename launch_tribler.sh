#!/bin/bash
# Load installation parameters.
source install_params.sh

# Apply configuration.
# TODO: include arguments to only apply configuration.
cd $git_dir/audio && ./setup.sh --config --tribler
cd $git_dir && tribler/src/./tribler.sh > $git_dir/tribler/tribler.log
