#!/bin/bash
# Sets up system to listen audio on Ubuntu 22.04. Run with:
# chmod +x setup.sh
# ./setup.sh

# TODO: install git
# TODO: install wget

# Load helper scripts
source configure_tribler.sh
chmod +x configure_tribler.sh
source install_tribler.sh
chmod +x install_tribler.sh
source configure_headphones.sh
chmod +x configure_headphones.sh
source configure_picard.sh
chmod +x configure_picard.sh

# Specify configuration parameters.
# Download dir.
git_dir=~/git
dld_dir=~/Downloads/TriblerDownloads/music_blackhole
#tribler_music_out_dir=~/Music/Library/Tribler # TODO: make sure Tribler moves towards this directory
tribler_music_out_dir=~/Downloads/TriblerDownloads # TODO: make sure Tribler moves towards this directory
target_blackhole=~/Music/Torrentsasdf
beets_database_dir=~/Music/database
beets_database_filename="musiclibrary.db"
tribler_config_root_dir=~/.Tribler

# Tribler configuration lines:
#watch_folder_header="[watch_folder]"
watch_folder_header_identifier="watch_folder"
enabled_line_two="    enabled = True"
disabled_line_two="    enabled = False"
watch_dir_line_identifier="    directory = "
desired_watch_dir_line="    directory = $target_blackhole"

# Specify Picard configuration settings.
picard_config_root_dir=~//snap/picard/
picard_music_out_dir=~/Music/Library/Picard
# TODO: find the difference between current and starting dir.
# TODO: Set to: from tribler_music_out_dir to headphones_music_output_dir
current_dir_line_identifier="current_directory="
# TODO: Set to:tribler_music_out_dir headphones_music_output_dir
starting_dir_line_identifier="starting_directory_path="
#Set to:picard_music_out_dir
move_files_to_line_identifier="move_files_to="
# Set to:true
move_files_bool_line_identifier="move_files="
analyse_new_files_line_identifier="analyze_new_files="
rename_files_line_identifier="rename_files="

# Specify Headphones configuration settings.
headphones_config_root_dir=~/git/headphones/
headphones_music_output_dir=~/Music/Library/Headphones # TODO: make sure Tribler moves towards this directory
headphones_lossless_music_output_dir="$headphones_music_output_dir/lossless"

# Create directories:
mkdir -p $git_dir
mkdir -p $tribler_music_out_dir
mkdir -p $picard_music_out_dir
mkdir -p $headphones_music_output_dir
mkdir -p $headphones_lossless_music_output_dir

mkdir -p $target_blackhole
mkdir -p $beets_database_dir

# Temporarily configure headphones first
find_headphones_config_file "$headphones_config_root_dir" "$target_blackhole" "$tribler_music_out_dir" "$headphones_music_output_dir" "$headphones_lossless_music_output_dir"
exit 5


# Instal Tribler
install_tribler_beta_from_deb

# Install Beets.
pip install beets

# Install Picard.
snap install picard

# Install Headphones.
cd $git_dir
git clone git@github.com:rembo10/headphones.git


# Configure Tribler
# Make it read input torrents from blackhole.
find_tribler_config_file "$tribler_config_root_dir" "$watch_folder_header_identifier" "$enabled_line_two" "$disabled_line_two" "$watch_dir_line_identifier" "$desired_watch_dir_line"
# TODO:Make it output music torrents to music_blackhole
# TODO:Set level of anonymity.

# Configure Headphones
# TODO: Specify to output torrents to blackhole dir.
find_headphones_config_file "$headphones_config_root_dir" "$target_blackhole" "$tribler_music_out_dir" "$headphones_music_output_dir" "$headphones_lossless_music_output_dir"


# Configure Picard
find_picard_config_file "$picard_config_root_dir" "$current_dir_line_identifier" "$starting_dir_line_identifier" "$move_files_bool_line_identifier" "$move_files_to_line_identifier"  "$analyse_new_files_line_identifier" "$rename_files_line_identifier" "$headphones_music_output_dir" "$picard_music_out_dir"

# Configure Beets.
# Create configuration file.
beet config -e
# Get location of configuration file.
beet_config_path=$(beet config -p)
# TODO: assert beet_config_path ends in .yaml

# OverWrite music target directory into beets config .yaml:
# Don't run beets on tribler music, run it on Picard output.
#echo "directory: $tribler_music_out_dir" > $beet_config_path
#echo "directory: $picard_music_out_dir" > $beet_config_path

# Append library database file location to beets config .yaml:
# Don't run beets on tribler music, run it on Picard output.
#echo "library: $tribler_music_out_dir/$beets_database_filename" >> $beet_config_path
echo "library: $picard_music_out_dir/$beets_database_filename" >> $beet_config_path
# TODO: assert filecontent is correct.




# TODO: Run Tribler in background at boot.
#tribler/src/tribler.sh  > tribler.log

# TODO: Run crontab every 30 minutes to import music in background (starting at boot).
# TODO: include argument to Skip by default to ensure it runs smoothly in background.
#beet import $tribler_music_out_dir

# TODO: Run Headpohnes in background at boot.
#python Headphones.py

#@reboot  cd ~/git/tribler/src/ && tribler.sh  > tribler.log
#@reboot cd ~/git/headphones && python Headphones.py
#@reboot picard