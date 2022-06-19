#!/bin/bash
# Runs Tribler at boot.

run_tribler_source_install() {
    local git_dir="$1"
    cd $git_dir
    
    # Run tribler
    tribler/src/./tribler.sh  > tribler.log
}

create_tribler_autostart_entry() {
    local git_dir="$1"
    local startup_script_path="$2"
    local repo_name="$3"
    
    echo "[Desktop Entry]" > "$startup_script_path"
    echo "Type=Application" >> "$startup_script_path"
    echo "Exec=$git_dir/$repo_name/launch_tribler.sh" >> "$startup_script_path"
    echo "Hidden=false" >> "$startup_script_path"
    echo "NoDisplay=false" >> "$startup_script_path"
    echo "X-GNOME-Autostart-enabled=true" >> "$startup_script_path"
    echo "Name[en_US]=tribler" >> "$startup_script_path"
    echo "Name=tribler" >> "$startup_script_path"
    echo "Comment[en_US]=" >> "$startup_script_path"
    echo "Comment=" >> "$startup_script_path"

    chmod +x launch_tribler.sh
}

run_tribler_at_boot_source_install() {
    local git_dir="$1"

    # Create cronjob command
    cron_command="@reboot cd $git_dir && env DISPLAY=:0 tribler/src/./tribler.sh > $git_dir/tribler.log"
    

    # Check if crantab contains run at boot line already:
    found_cron_command=$(crontab -l | grep "$cron_command")
    if [ "$found_cron_command" == "" ]; then

        # Add cronjob to crontab if it is not in yet.
        write_cronjob "$git_dir" "tribler_cron" "$cron_command"
    elif [ "$found_cron_command" == "$cron_command" ]; then
        echo "cronjob is already in crontab."
    else
        echo "Error, the cronjob was not correctly in the crontab"
        echo "(most likely the cron_command:$cron_command is in in duplo):"
        echo ""
        crontab -l
        echo ""
        echo "Remove the (duplicate) cron_command(s) from the crontab -e"
        echo "and try again."
        exit 6
    fi
    
}

write_cronjob() {
    local git_dir="$1"
    local temp_cronjob_filename="$2"
    local cron_command="$3"

    # Write out the current crontab into a new file with filemname in var mycron.
    crontab -l > $temp_cronjob_filename
    
    #echo new cron into cron file through append.
    echo "$cron_command" >> $temp_cronjob_filename
    
    #install new cron file
    crontab $temp_cronjob_filename
    

    # TODO: Verify the temp_cronjob_filecontent equals the crontab -e output.
    #rm $temp_cronjob_filename
}