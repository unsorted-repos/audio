#!/bin/bash
# Sets up system to listen audio on Ubuntu 22.04. Run with:
# chmod +x setup.sh
# ./setup.sh

# TODO: install git
# TODO: install wget

# Load installation parameters.
source install_params.sh

# Load helper scripts
source configure_tribler.sh
chmod +x configure_tribler.sh
source install_tribler.sh
chmod +x install_tribler.sh
source configure_headphones.sh
chmod +x configure_headphones.sh
source configure_picard.sh
chmod +x configure_picard.sh
source run_tribler_at_boot.sh
chmod +x run_tribler_at_boot.sh

# Create directories:
mkdir -p $startup_script_dir
mkdir -p $git_dir
mkdir -p $tribler_music_out_dir
mkdir -p $picard_music_out_dir
mkdir -p $headphones_music_output_dir
mkdir -p $headphones_lossless_music_output_dir

mkdir -p $target_blackhole
mkdir -p $beets_database_dir

# Ensure Tribler runs at boot.

# Make it read input torrents from blackhole.
find_tribler_config_file "$tribler_config_root_dir" "$watch_folder_header_identifier" "$enabled_line_two" "$disabled_line_two" "$watch_dir_line_identifier" "$desired_watch_dir_line"
# Set level of anonymity.
set_download_defaults_for_all_tribler_configs "$tribler_config_root_dir" "$download_settings_header_identifier" "$number_hops_identifier" "$number_hops" "$seeding_mode_identifier" "$seeding_mode" "$seeding_ratio_identifier" "$seeding_ratio"
# TODO:Make it output music torrents to music_blackhole
exit 5



# Instal Tribler
#install_tribler_beta_from_deb
install_tribler_from_source $git_dir

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
# Set level of anonymity.
set_download_defaults_for_all_tribler_configs "$tribler_config_root_dir" "$download_settings_header_identifier" "$number_hops_identifier" "$number_hops" "$seeding_mode_identifier" "$seeding_mode" "$seeding_ratio_identifier" "$seeding_ratio"
# TODO:Make it output music torrents to music_blackhole

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




# Run Tribler GUI at boot.
# run_tribler_at_boot_source_install $git_dir # Does not work for GUI application.
create_tribler_autostart_entry $git_dir $startup_script_path $repo_name


# TODO: Run crontab every 30 minutes to import music in background (starting at boot).
# TODO: include argument to Skip by default to ensure it runs smoothly in background.
#beet import $tribler_music_out_dir

# TODO: Run Headpohnes in background at boot.
#python Headphones.py

#@reboot  cd ~/git/tribler/src/ && tribler.sh  > tribler.log
#@reboot cd ~/git/headphones && python Headphones.py
#@reboot picard