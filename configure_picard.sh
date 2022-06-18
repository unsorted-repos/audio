#!/bin/bash
# Configures Picard

# Example location:
#/home/name/snap/picard/1032/.config/MusicBrainz/Picard.ini
# TODO: specify file renaming sceme.
# TODO: Get API key for AccousticID for fingerprinting: https://acoustid.org/login?return_url=https%3A%2F%2Facoustid.org%2Fapi-key
# TODO: Ask if user wants to store ratings in MusicBrains email account (email identifiable).

find_picard_config_file(){
    local picard_config_root_dir="$1"
    local current_dir_line_identifier="$2"
    local starting_dir_line_identifier="$3" 
    local move_files_bool_line_identifier="$4"
    local move_files_to_line_identifier="$5"
    local analyse_new_files_line_identifier="$6"
    local rename_files_line_identifier="$7"
    local headphones_music_output_dir="$8"
    local picard_music_out_dir="$9"
    # Find the configruation filepaths and loop over them.
    find $picard_config_root_dir/* -type f -name "Picard.ini" -print0 | while read -d $'\0' file
    do
        echo "file=$file" 1>&2
        # Set default folder on which to run.
        $(change_line "$current_dir_line_identifier" "$current_dir_line_identifier/$headphones_music_output_dir" "$file")

        # Set starting dir. TODO: Determine purpose.
        $(change_line "$starting_dir_line_identifier" "$starting_dir_line_identifier/$headphones_music_output_dir" "$file")

        # Set music output dir of Picard
        local move_files_bool_line="$move_files_bool_line_identifier""true"
        $(change_line "$move_files_bool_line_identifier" "$move_files_bool_line" "$file")
        $(change_line "$move_files_to_line_identifier" "$move_files_to_line_identifier/$picard_music_out_dir" "$file")
        
        
        # Set analyse new files automatically to true.
        local analyse_new_files_line="$analyse_new_files_line_identifier""true"
        $(change_line "$analyse_new_files_line_identifier" "$analyse_new_files_line" "$file")

        # Ensure Picard renames the files according to some format.
        local rename_files_line="$rename_files_line_identifier""true"
        #echo "rename_files_line=$rename_files_line" 1>&2
        $(change_line "$rename_files_line_identifier" "$rename_files_line" "$file")
    done
}