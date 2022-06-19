#!/bin/bash
# Installs Tribler.

# Instal Tribler
install_tribler_from_source() {
    cd $git_dir
    git clone https://github.com/tribler/tribler
    cd tribler 
    git pull
    cd ..
    conda deactivate
    yes | sudo apt install git libssl-dev libx11-6 libgmp-dev python3 python3-minimal python3-pip python3-libtorrent python3-pyqt5 python3-pyqt5.qtsvg python3-scipy
    pip3 install --upgrade -r tribler/requirements.txt
    pip install sentry-sdk
    chmod +x tribler/src/tribler.sh
    # Run tribler
    #/tribler/src/tribler.sh  > tribler.log
}
# Unstable performance, so this installation method is commented out.
#$(install_tribler_from_source)

install_tribler_from_snap() {
    sudo snap install tribler-bittorrent --beta

    # Remove snap install of Tribler:
    #sudo snap remove tribler-bittorrent --beta
}
# Beta is not safe for arbitrary user.
#$(install_tribler_from_snap)

install_tribler_from_deb() {
    wget https://github.com/Tribler/tribler/releases/download/v7.11.0/tribler_7.11.0_all.deb
    #sudo apt-get install ./tribler_7.11.0_all.deb # Does not work.
    sudo dpkg -i tribler_7.11.0_all.deb

    # Launch Tribler in terminal by typing:
    # tribler

    # Remove tribler:
    #sudo dpkg -r tribler
}
# Version 7.11 does not work on Ubuntu 22.04: https://github.com/Tribler/tribler/issues/6895#issuecomment-1122490517
#$(install_tribler_from_deb)

install_tribler_beta_from_deb() {
    wget https://jenkins-ci.tribler.org/job/Build-Tribler_release/job/Build-Ubuntu64/522/artifact/tribler/build/debian/tribler_7.12.0-alpha.4-3-g0fb222e62_all.deb
    sudo dpkg -i tribler_7.12.0-alpha.4-3-g0fb222e62_all.deb
    # Launch Tribler in terminal by typing:
    # tribler

    # Remove tribler:
    #sudo dpkg -r tribler
}
# Beta is not safe for arbitrary user (but it works).
#$(install_tribler_beta_from_deb)
