#!/bin/bash
# Specifies the parameters that are used during installation.

# Specify configuration parameters.
repo_name="audio"
startup_script_dir=~/.config/autostart
startup_script_path=$startup_script_dir/tribler.desktop


# Download dir.
git_dir=~/git
dld_dir=~/Downloads/TriblerDownloads/music_blackhole


#tribler_music_out_dir=~/Music/Library/Tribler # TODO: make sure Tribler moves towards this directory
tribler_music_out_dir=~/Downloads/TriblerDownloads # TODO: make sure Tribler moves towards this directory
target_blackhole=~/Music/Torrentsasdf
beets_database_dir=~/Music/Library/Beets/
beets_database_filename="beets.db"
beet_config_dir="/home/$(whoami)/.config/beets/"
beet_config_filename="config.yaml"

tribler_config_root_dir=~/.Tribler

# Tribler configuration lines:
#watch_folder_header="[watch_folder]"
watch_folder_header_identifier="watch_folder"
enabled_line_two="    enabled = True"
disabled_line_two="    enabled = False"
watch_dir_line_identifier="    directory = "
desired_watch_dir_line="    directory = $target_blackhole"

# Download settings.
download_settings_header_identifier="download_defaults"
number_hops_identifier="    number_hops = "
seeding_mode_identifier="    seeding_mode = "
seeding_ratio_identifier="    seeding_ratio = "
number_hops='2'
seeding_mode='ratio'
seeding_ratio='5.0'

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