#!/bin/bash
#
# This script extracts metrics.
#
# NB: add the flag "-x" after "!/bin/bash" for full verbose of commands.
# Julien Cohen-Adad 2018-01-30

# Exit if user presses CTRL+C (Linux) or CMD+C (OSX)
trap "echo Caught Keyboard Interrupt within script. Exiting now.; exit" INT

# Create results folder
if [ ! -d ${PATH_RESULTS} ]; then
  mkdir ${PATH_RESULTS}
fi

# mt
# ==============================================================================
cd mt
# compute MTR in WM in each level prescribed by METRICS_VERT_LEVEL
sct_extract_metric -i mtr.nii.gz -l 51 -method map -vert ${METRICS_VERT_LEVEL} -perlevel 1 -o ${PATH_RESULTS}/mtr_in_WM.xls
## compute MTR in WM and average across level(s) prescribed by METRICS_VERT_LEVEL
# sct_extract_metric -i mtr.nii.gz -l 51 -method map -vert ${METRICS_VERT_LEVEL} -perlevel 0 -o ${PATH_RESULTS}/mtr_in_WM.xls
## compute MTR in the dorsal columns in each level prescribed by METRICS_VERT_LEVEL
# sct_extract_metric -i mtr.nii.gz -l 53 -method map -vert ${METRICS_VERT_LEVEL} -perlevel 1 -o ${PATH_RESULTS}/mtr_in_DC.xls
## compute MTR in WM between slices 5 and 15 and averaged across slices
# sct_extract_metric -i mtr.nii.gz -l 51 -method map -z 5:15 -perslice 0 -o ${PATH_RESULTS}/mtr_in_WM_z5-15.xls
cd ..
