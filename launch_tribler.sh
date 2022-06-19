#!/bin/bash
# TODO: read hardcoded variables from a single file.

# Apply configuration.
# TODO: include arguments to only apply configuration.
# TODO: make paths variable based on single source file.
cd /home/name/git/audio && ./setup.sh
cd /home/name/git && tribler/src/./tribler.sh > /home/name/git/tribler.log
