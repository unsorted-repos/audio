#!/bin/bash
# Configures Tribler

# TODO: make sure Tribler moves towards the directory: $tribler_music_out_dir

# Specify helper functions
#######################################
# 
# Local variables:
# 
# Globals:
#  None.
# Arguments:
#   
# Returns:
#  0 if 
#  7 if 
# Outputs:
#  None.
# TODO(a-t-0): change root with Global variable.
#######################################
# Structure:Parsing
# allows a string with spaces, hence allows a line
file_contains_string() {
	local string="$1"
	local relative_filepath="$2"
	if grep -q "$string" "$relative_filepath" ; then    
		echo "FOUND"; 
	else
		echo "NOTFOUND";
	fi
}

escape_slashes() {
    sed 's/\//\\\//g' 
}

change_line() {
    local old_line_pattern="$1"
    local new_line="$2"
    local filepath="$3"

    local new=$(echo "${new_line}" | escape_slashes)
    # FIX: No space after the option i.
    sed -i.bak '/'"${old_line_pattern}"'/s/.*/'"${new}"'/' "${filepath}"
    mv "${filepath}.bak" /tmp/
}

append_watch_folder_to_tribler_config() {
    watch_folder_header_identifier="$1"
    enabled_line_two="$2"
    desired_watch_dir_line="$3"
    filepath="$4"

    printf \[$watch_folder_header_identifier] | sudo tee -a "$filepath"
    printf "\n" | sudo tee -a "$filepath"
    echo "$enabled_line_two" | sudo tee -a "$filepath"
    echo "$desired_watch_dir_line" | sudo tee -a "$filepath"

    # TODO: assert the file contents is in correctly.
}


# Make it read input torrents from blackhole.
set_tribler_watch_folder_config() {
    local config_filepath="$1"
    local watch_folder_header_identifier="$2"
    local enabled_line_two="$3"
    local disabled_line_two="$4"
    local watch_dir_line_identifier="$5"
    local desired_watch_dir_line="$6"

    if [ "$(file_contains_string "$watch_folder_header_identifier" "$config_filepath")" == "FOUND" ]; then
        # Verify the enabled line is set.
        if [ "$(file_contains_string "$enabled_line_two" "$config_filepath")" == "NOTFOUND" ]; then
            if [ "$(file_contains_string "$disabled_line_two" "$config_filepath")" == "NOTFOUND" ]; then
                echo "Error, $config_filepath does not contain:\n$enabled_line_two nor\n$disabled_line_two" 1>&2
		        exit 5
            else
                # Overwrite the watch folder disabled line with the enabled line.
                $(change_line "$disabled_line_two" "$enabled_line_two" "$config_filepath")
            fi
        fi
        # Verify the directory line is set.
        if [ "$(file_contains_string "$watch_dir_line_identifier" "$config_filepath")" == "NOTFOUND" ]; then
            # Raise error.
            echo "Error, $config_filepath does not contain:\n$watch_dir_line_identifier" 1>&2
            exit 6
        fi
        
        # Overwrite the directory line.
        change_line "$watch_dir_line_identifier" "$desired_watch_dir_line" "$config_filepath"
        
    else
        echo "appending" 1>&2
        append_watch_folder_to_tribler_config "$watch_folder_header_identifier" "$enabled_line_two" "$desired_watch_dir_line" "$config_filepath"
    fi
}

append_download_settings_to_tribler_config() {
    local config_filepath="$1"
    local download_settings_header_identifier="$2"
    local number_hops_identifier="$3"
    local number_hops="$4"
    local seeding_mode_identifier="$5"
    local seeding_mode="$6"
    local seeding_ratio_identifier="$7"
    local seeding_ratio="$8"
    printf \[$download_settings_header_identifier] | sudo tee -a "$config_filepath"
    printf "\n" | sudo tee -a "$config_filepath"
    echo "$number_hops_identifier$number_hops" | sudo tee -a "$config_filepath"
    echo "$seeding_mode_identifier$seeding_mode" | sudo tee -a "$config_filepath"
    echo "$seeding_ratio_identifier$seeding_ratio" | sudo tee -a "$config_filepath"

    # TODO: assert the file contents is in correctly.
}


set_download_defaults() {
    local config_filepath="$1"
    local download_settings_header_identifier="$2"
    local number_hops_identifier="$3"
    local number_hops="$4"
    local seeding_mode_identifier="$5"
    local seeding_mode="$6"
    local seeding_ratio_identifier="$7"
    local seeding_ratio="$8"

    if [ "$(file_contains_string "$download_settings_header_identifier" "$config_filepath")" == "FOUND" ]; then
        
        # Verify the enabled line is set.
        if [ "$(file_contains_string "$number_hops_identifier" "$config_filepath")" == "NOTFOUND" ]; then
            echo "Error, $config_filepath does not contain:\n$number_hops_identifier" 1>&2
            exit 5
        else
            $(change_line "$number_hops_identifier" "$number_hops_identifier$number_hops" "$config_filepath")
        fi

        if [ "$(file_contains_string "$seeding_mode_identifier" "$config_filepath")" == "NOTFOUND" ]; then
            echo "Error, $config_filepath does not contain:\n$seeding_mode_identifier" 1>&2
            exit 5
        else
            $(change_line "$seeding_mode_identifier" "$seeding_mode_identifier$seeding_mode" "$config_filepath")
        fi

        if [ "$(file_contains_string "$seeding_ratio_identifier" "$config_filepath")" == "NOTFOUND" ]; then
            echo "Error, $config_filepath does not contain:\n$seeding_ratio_identifier" 1>&2
            exit 5
        else
            $(change_line "$seeding_ratio_identifier" "$seeding_ratio_identifier$seeding_ratio" "$config_filepath")
        fi

        # Verify the directory line is set.
        if [ "$(file_contains_string "$download_settings_header_identifier" "$config_filepath")" == "NOTFOUND" ]; then
            # Raise error.
            echo "Error, $config_filepath does not contain after setting val:\n$download_settings_header_identifier" 1>&2
            exit 6
        fi
        if [ "$(file_contains_string "$number_hops_identifier" "$config_filepath")" == "NOTFOUND" ]; then
            # Raise error.
            echo "Error, $config_filepath does not contain after setting val:\n$number_hops_identifier" 1>&2
            exit 6
        fi
        if [ "$(file_contains_string "$seeding_mode_identifier" "$config_filepath")" == "NOTFOUND" ]; then
            # Raise error.
            echo "Error, $config_filepath does not contain after setting val:\n$seeding_mode_identifier" 1>&2
            exit 6
        fi
        if [ "$(file_contains_string "$seeding_ratio_identifier" "$config_filepath")" == "NOTFOUND" ]; then
            # Raise error.
            echo "Error, $config_filepath does not contain after setting val:\n$seeding_ratio_identifier" 1>&2
            exit 6
        fi
             
        # Overwrite the directory line. TODO: verify if needed.
        #$(change_line "$download_settings_header_identifier" "$desired_watch_dir_line" "$config_filepath")
        
    else
        #echo "appending" 1>&2
        #echo "config_filepath=$config_filepath" 1>&2
        #echo "download_settings_header_identifier=$download_settings_header_identifier" 1>&2
        #echo "" 1>&2
        append_download_settings_to_tribler_config "$config_filepath" "$download_settings_header_identifier" "$number_hops_identifier" "$number_hops" "$seeding_mode_identifier" "$seeding_mode" "$seeding_ratio_identifier" "$seeding_ratio"
    fi
}

find_tribler_config_file(){
    local tribler_config_root_dir="$1"
    local watch_folder_header_identifier="$2"
    local enabled_line_two="$3"
    local disabled_line_two="$4"
    local watch_dir_line_identifier="$5"
    local desired_watch_dir_line="$6"
    
    # Find the configruation filepaths and loop over them.
    find $tribler_config_root_dir/*/ -type f -name "triblerd.conf" -print0 | while read -d $'\0' file
    do
        echo "file=$file" 1>&2
        $(set_tribler_watch_folder_config $file "$watch_folder_header_identifier" "$enabled_line_two" "$disabled_line_two" "$watch_dir_line_identifier" "$desired_watch_dir_line")
    done
}

set_download_defaults_for_all_tribler_configs(){
    local tribler_config_root_dir="$1"
    local download_settings_header_identifier="$2"
    local number_hops_identifier="$3"
    local number_hops="$4"
    local seeding_mode_identifier="$5"
    local seeding_mode="$6"
    local seeding_ratio_identifier="$7"
    local seeding_ratio="$8"
    
    # Find the configruation filepaths and loop over them.
    find $tribler_config_root_dir/*/ -type f -name "triblerd.conf" -print0 | while read -d $'\0' file
    do
        echo "set_download_defaults in=$file" 1>&2
        set_download_defaults "$file" "$download_settings_header_identifier" "$number_hops_identifier" "$number_hops" "$seeding_mode_identifier" "$seeding_mode" "$seeding_ratio_identifier" "$seeding_ratio"
    done
}