#!/bin/bash
#
# This is a wrapper to processing scripts, that loops across subjects.
#
# Usage:
#   ./run_process.sh <script> <path_data>
#     script: the script to run
#     path_data: the absolute path that contains all subject folders
#
# Example:
#   ./run_process.sh extract_metrics.sh /Users/julien/data/spine_generic/
#
# Add the flag "-x" after "!/bin/bash" for full verbose of commands.
# Julien Cohen-Adad 2018-07-20

# Exit if user presses CTRL+C (Linux) or CMD+C (OSX)
trap "echo Caught Keyboard Interrupt within script. Exiting now.; exit" INT

# # Fetch OS type (used to open QC folder)
# if uname -a | grep -i  darwin > /dev/null 2>&1; then
#   # OSX
#   export OPEN_CMD="open"
# elif uname -a | grep -i  linux > /dev/null 2>&1; then
#   # Linux
#   export OPEN_CMD="xdg-open"
# fi

# Build color coding (cosmetic stuff)
Color_Off='\033[0m'       # Text Reset
Green='\033[0;92m'       # Yellow
On_Black='\033[40m'       # Black

# Build syntax for process execution
CMD=`pwd`/$1

# Go to path data folder that encloses all subjects' folders
cd ${PATH_DATA}

# If the variable SUBJECTS does not exist (commented), get list of all subject
# folders from current directory
if [ -z ${SUBJECTS} ]; then
  echo "Processing all subjects present in: $PATH_DATA."
  SUBJECTS=`ls -d */`
else
  echo "Processing subjects specified in parameters.sh."
fi

# Loop across subjects
for subject in ${SUBJECTS[@]}; do
  # Display stuff
  printf "${Green}${On_Black}\n===============================\n\
PROCESSING SUBJECT: ${subject}\n===============================\n\
  ${Color_Off}"
  # Go to subject folder
  cd ${subject}
  # Run process
  $CMD
  # Go back to parent folder
  cd ..
done
