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


POSITIONAL_ARGS=()

# Specify default argument values.
config_flag='false'
install_flag='false'
run_at_boot_flag='false'

beets_flag='false'
headphones_flag='false'
picard_flag='false'
tribler_flag='false'

print_usage() {
  printf "\nDefault usage, write:"
  printf "\n./setup.sh -c -i -t\n                         to configure and install tribler."

  printf "\nSupported options:"
  
  printf "\n-c | --config            configure service(s)."
  printf "\n-i | --install           install service(s)."
  printf "\n-r | --runboot           ensure service(s) run at boot.\n"

  printf "\n-b | --beets             Apply configuration, installation and/or run@boot to Beets."
  printf "\n-h | --headphones        Apply configuration, installation and/or run@boot to Headphones."
  printf "\n-p | --picard            Apply configuration, installation and/or run@boot to Picard."
  printf "\n-t | --tribler           Apply configuration, installation and/or run@boot to Tribler."
  printf "\n\n"
}

# print the usage if no arguments are given
[ $# -eq 0 ] && { print_usage; exit 1; }

while [[ $# -gt 0 ]]; do
  case $1 in
    -c|--config)
	    config_flag='true'
      shift # past argument
      ;;
    -i|--install)
      install_flag='true'
      shift # past argument
      ;;
    -r|--runboot)
	    # Start by setting the ssh-deploy key to the GitHub build status 
	    # repository.
      run_at_boot_flag='true'
      shift # past argument
      ;;
    -b|--beets)
      beets_flag='true'
      shift # past argument
      ;;
    -h|--headphones)
      headphones_flag='true'
      shift # past argument
      ;;
    -p|--picard)
      picard_flag='true'
      shift # past argument
      ;;
    -t|--tribler)
      tribler_flag='true'
      shift # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      print_usage
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

echo "config_flag                   = ${config_flag}"
echo "install_flag                    = ${install_flag}"
echo "run_at_boot_flag                    = ${run_at_boot_flag}"

echo "beets_flag                    = ${beets_flag}"
echo "headphones_flag                   = ${headphones_flag}"
echo "picard_flag                   = ${picard_flag}"
echo "tribler_flag                    = ${tribler_flag}"


# Perform installation.
if [ "$install_flag" == "true" ]; then

  # Create directories:
  mkdir -p $startup_script_dir
  mkdir -p $git_dir
  mkdir -p $tribler_music_out_dir
  mkdir -p $picard_music_out_dir
  mkdir -p $headphones_music_output_dir
  mkdir -p $headphones_lossless_music_output_dir

  mkdir -p $target_blackhole
  mkdir -p $beets_database_dir

  if [ "$beets_flag" == "true" ]; then
    # Install Beets.
    pip install beets
  fi
  if [ "$headphones_flag" == "true" ]; then
    # Install Headphones.
    cd $git_dir
    git clone git@github.com:rembo10/headphones.git
  fi
  if [ "$picard_flag" == "true" ]; then
    # Install Picard.
    snap install picard
  fi
  if [ "$tribler_flag" == "true" ]; then
    # Instal Tribler
    #install_tribler_beta_from_deb
    install_tribler_from_source $git_dir
  fi
fi

# Perform configuration.
if [ "$config_flag" == "true" ]; then
  if [ "$beets_flag" == "true" ]; then
    # Create configuration file.
    beet config -e
    # Get location of configuration file.
    beet_config_path=$(beet config -p)
    # TODO: assert beet_config_path ends in .yaml

    # Option I: OverWrite music target directory into beets config .yaml:
    #echo "directory: $tribler_music_out_dir" > $beet_config_path
    #echo "directory: $picard_music_out_dir" > $beet_config_path

    # Option II: Append library database file location to beets config .yaml:
    #echo "library: $tribler_music_out_dir/$beets_database_filename" >> $beet_config_path
    echo "library: $picard_music_out_dir/$beets_database_filename" >> $beet_config_path
    
    # TODO: assert Picard config filecontent is correct.
  fi
  if [ "$headphones_flag" == "true" ]; then
    # TODO: Specify to output torrents to blackhole dir.
    find_headphones_config_file "$headphones_config_root_dir" "$target_blackhole" "$tribler_music_out_dir" "$headphones_music_output_dir" "$headphones_lossless_music_output_dir"
  fi
  if [ "$picard_flag" == "true" ]; then
    find_picard_config_file "$picard_config_root_dir" "$current_dir_line_identifier" "$starting_dir_line_identifier" "$move_files_bool_line_identifier" "$move_files_to_line_identifier"  "$analyse_new_files_line_identifier" "$rename_files_line_identifier" "$headphones_music_output_dir" "$picard_music_out_dir"
  fi
  if [ "$tribler_flag" == "true" ]; then
    # Make it read input torrents from blackhole.
    find_tribler_config_file "$tribler_config_root_dir" "$watch_folder_header_identifier" "$enabled_line_two" "$disabled_line_two" "$watch_dir_line_identifier" "$desired_watch_dir_line"
    # Set level of anonymity.
    set_download_defaults_for_all_tribler_configs "$tribler_config_root_dir" "$download_settings_header_identifier" "$number_hops_identifier" "$number_hops" "$seeding_mode_identifier" "$seeding_mode" "$seeding_ratio_identifier" "$seeding_ratio"
    # TODO:Make it output music torrents to music_blackhole
  fi
fi

# Perform ensuring services run at boot.
if [ "$run_at_boot_flag" == "true" ]; then
  if [ "$beets_flag" == "true" ]; then
    # TODO: Run crontab every 30 minutes to import music in background (starting at boot).
    # TODO: include argument to Skip by default to ensure it runs smoothly in background.
    #beet import $tribler_music_out_dir
    pass
  fi
  if [ "$headphones_flag" == "true" ]; then
    # TODO: Run Headpohnes in background at boot.
    #python Headphones.py
    #@reboot cd ~/git/headphones && python Headphones.py
    pass
  fi
  if [ "$picard_flag" == "true" ]; then
    # TODO: Run crontab every 30 minutes to import music in background (starting at boot).
    #@reboot picard
    pass
  fi
  if [ "$tribler_flag" == "true" ]; then
    # run_tribler_at_boot_source_install $git_dir # Does not work for GUI application.
    create_tribler_autostart_entry $git_dir $startup_script_path $repo_name # with GUI
  fi
fi