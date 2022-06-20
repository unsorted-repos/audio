#!/bin/bash
# Configures listenbrainz to get listen recommendations.

create_listenbrainz_account(){
    echo "Please create a listenbrainz account." 1>&2
    echo "Enter your email twice; once to sign up, and after logging in and"
    echo " verifying your email, go to account settings and type your email again."
    echo "Then verify your email (again)." 1>&2
    xdg-open https://listenbrainz.org/login/
}
#create_listenbrainz_account

link_spotify_to_listenbrainz(){
    echo "Ensure you are logged into listenbrainz." 1>&2
    echo "For Spotify, please select: Record listening history" 1>&2
    xdg-open https://listenbrainz.org/profile/music-services/details/
}
#link_spotify_to_listenbrainz

# TODO: set up listenbrainz API:
# https://listenbrainz.readthedocs.io/en/production/dev/api/


# Source: https://musicbrainz.org/doc/MusicBrainz_Enabled_Applications
install_tauonmb_player_for_linux(){
    # Source: https://flathub.org/apps/details/com.github.taiko2k.tauonmb
    yes | sudo apt install flatpak
    flatpak install -y flathub org.gnome.Platform//3.42
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub com.github.taiko2k.tauonmb

}
#install_tauonmb_player_for_linux

# Run tuaonmb player with:
# TODO: Identify where config is saved, enable listenbrainz and ask user to provide listenbrains api.
#flatpak run com.github.taiko2k.tauonmb

# TODO: get listenbrainz data:
# Source https://calliope-music.readthedocs.io/en/latest/
get_listenbrainz_listen_history() {
    pip install calliope-music
    pip install calliope-music[listenbrainz]
    pip install pylistenbrainz

    cpe listenbrainz-history --user=some_username tracks

}
get_listenbrainz_listen_history

get_spotify_data(){
    # Source: https://calliope-music.readthedocs.io/en/latest/getting-data/api-keys.html#spotify
    
    echo "Login to the spotify developer account." 1>&2
    xdg-open https://developer.spotify.com/dashboard/applications
    read -p "Enter spotify clientID: " client_id
    read -p "Enter spotify client secret: " client_secret
    

    # TODO: output data to:  $HOME/.config/calliope/calliope.conf
    #[spotify]
    #client-id = 044a880f7e989352f1d243e39648e653
    #client-secret = 54967576893ae3f9c3568a1977016e8d
    #redirect-uri = http://localhost:8080/
    
    # Load client data
    #client_id
    #client_secret
}

# SKIP: Set up local listenbrainz server:
# Source: https://github.com/metabrainz/listenbrainz-server


# TODO:
# Source: https://listenbrainz.org/add-data/
# These are programs that submit listens to ListenBrainz:
#
#    mpd, a flexible, powerful, server-side application for playing music: listenbrainz-mpd, wylt
#    Rhythmbox, a music playing application for GNOME: rhythmbox-plugin-listenbrainz
#    Lollypop, a modern music player for GNOME
#    Rescrobbled, a universal Linux scrobbler for MPRIS enabled players
#    Last.fm Scrobbler, an extension for Firefox and Chrome
#    Simple Last.fm Scrobbler, for Android devices
#    VLC Listenbrainz plugin, cross-platform plugin for VLC player
#    Web Scrobbler, an extension for Firefox and Chromium-based browsers
#    Pano Scrobbler, a scrobbling application for Android Devices


# TODO: Get data from spotify, download it, then add it to headphones.

# TODO: Get playlists from spotify, download them and re-upload them to listenbrainz