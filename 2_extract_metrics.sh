#!/bin/bash
#
# This script extracts metrics.
#
# NB: add the flag "-x" after "!/bin/bash" for full verbose of commands.
# Julien Cohen-Adad 2018-01-30

# Exit if user presses CTRL+C (Linux) or CMD+C (OSX)
trap "echo Caught Keyboard Interrupt within script. Exiting now.; exit" INT


# mt
# ===========================================================================================
cd mt
# create output folder
mkdir ${PATH_RESULTS}/mtr
# compute MTR in WM
sct_extract_metric -i mtr.nii.gz -l 51 -method map -o ${PATH_RESULTS}/mtr/mtr_in_WM.xls
# compute MTR in dorsal columns
sct_extract_metric -i mtr.nii.gz -l 53 -method map -o ${PATH_RESULTS}/mtr/mtr_in_DC.xls
# compute FA in lateral funiculi
sct_extract_metric -i mtr.nii.gz -l 54 -method map -o ${PATH_RESULTS}/mtr/mtr_in_LF.xls
cd ..
