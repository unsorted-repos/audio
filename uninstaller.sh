#!/bin/bash
# Removes software packages

# Uninstal Beets
uninstall_beets() {
    yes | sudo apt remove beets
    yes | pip uninstall beets
    # TODO: remove configuration files.
    rm -r ~/.config/beets
}

# Uninstal Picard
uninstall_picard() {
    sudo apt remove picard
    # TODO: remove configuration files.
}

# Uninstal Picard
uninstall_picard() {
    sudo apt remove picard
    # TODO: remove configuration files.
}

# Uninstal Tribler
uninstall_tribler_from_source() {
    sudo apt remove tribler
    # TODO: remove configuration files.
}


