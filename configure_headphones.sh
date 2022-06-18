#!/bin/bash
# Configures Headphones

# Example location:
#~/git/headphones/config.ini


change_lines_if_starts_with_pattern() {
    local old_line_pattern="$1"
    local new_line="$2"
    local filepath="$3"

    local new=$(echo "${new_line}" | escape_slashes)
    # FIX: No space after the option i.
    sed -i.bak '/^'"${old_line_pattern}"'/s/.*/'"${new}"'/' "${filepath}"
    mv "${filepath}.bak" /tmp/
}


find_headphones_config_file(){
    local headphones_config_root_dir="$1"
    local target_blackhole="$2"
    local tribler_music_out_dir="$3"
    local headphones_music_output_dir="$4"
    local headphones_lossless_music_output_dir="$5"
    

    # Find the configruation filepaths and loop over them.
    find $headphones_config_root_dir/* -type f -name "config.ini" -print0 | while read -d $'\0' file
    do
        echo "file=$file" 1>&2
        echo "headphones_lossless_music_output_dir=$headphones_lossless_music_output_dir" 1>&2

        # Set headphones torrent output dir=Tribler blackhole torrent input dir.
        #torrentblackhole_dir = /home/blackhole
        $(change_line "torrentblackhole_dir = " "torrentblackhole_dir = $target_blackhole" "$file")
        
        # Set headphones music input dir=Tribler download output dir.
        #download_torrent_dir = /home/tribler_download_dir
        $(change_line "download_torrent_dir = " "download_torrent_dir = $tribler_music_out_dir" "$file")

        # Set headphones post-processed music output dir.
        #destination_dir = /home/output_dir
        $(change_lines_if_starts_with_pattern "destination_dir = " "destination_dir = $headphones_music_output_dir" "$file")

        # Set headphones post-processed lossless music output dir.
        #lossless_destination_dir = /home/output_dir/lossless
        $(change_line "lossless_destination_dir = " "lossless_destination_dir = $headphones_lossless_music_output_dir" "$file")
        

        # Make Headphones look for blackhole torrents.
        $(change_line "headphones_indexer = " "headphones_indexer = 0" "$file")
        
        # Make Headphones move files to Headphones output dir.
        $(change_line "move_files = " "move_files = 1" "$file")
        
        # Make Headphones delete torrents when done.
        $(change_line "keep_torrent_files = " "keep_torrent_files = 1" "$file")
        
        # Make Headphones files during post-processing to some format convention.
        $(change_line "rename_files = " "rename_files = 1" "$file")
        
        # Make Headphones convert magnet links into torrents in the blackhole dir.
        $(change_lines_if_starts_with_pattern "magnet_links = " "magnet_links = 2" "$file")
        
        # Make Headphones download using torrents.
        $(change_line "prefer_torrents = " "prefer_torrents = 1" "$file")

        # Get torrent if there is at least 1 seeder.
        $(change_line "numberofseeders = " "numberofseeders = 1" "$file")

        # Prefer lossless audio if available.
        $(change_line "preferred_quality = " "preferred_quality = 1" "$file")

        # Remove download artifacts after downloading, during post-processing.
        $(change_line "cleanup_files = " "cleanup_files = 1" "$file")

        # Add album art if possible.
        $(change_line "add_album_art = " "add_album_art = 1" "$file")

        # Make Headphones correct invalid or missing metadata if possible.
        $(change_line "correct_metadata = " "correct_metadata = 1" "$file")

        # Put the album art into the song .mp3 file or whatever file is available.
        $(change_line "embed_album_art = " "embed_album_art = 1" "$file")

        # Put the lyrics art into the song .mp3 file or whatever file is available.
        $(change_line "embed_lyrics = " "embed_lyrics = 1" "$file")

        # It is not known to me at this point in time what this does, but it was changed.
        $(change_line "mpc_enabled = " "mpc_enabled = 0" "$file")

        # Make Headphones look for magnet links on the (new) piratebay.
        $(change_line "piratebay = " "piratebay = 1" "$file")

        # Specify proxy url.
        $(change_line "piratebay_proxy_url = " "piratebay_proxy_url = https://proxifiedpiratebay.org" "$file")
        
        # Specify seed ratio.
        # TODO: determine if this is requirement or target for user.
        $(change_line "piratebay_ratio = " "piratebay_ratio = 2" "$file")
        

    done
}








