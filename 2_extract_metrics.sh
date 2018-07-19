#!/bin/bash
#
# This script extracts metrics.
#
# NB: add the flag "-x" after "!/bin/bash" for full verbose of commands.
# Julien Cohen-Adad 2018-01-30

# Exit if user presses CTRL+C (Linux) or CMD+C (OSX)
trap "echo Caught Keyboard Interrupt within script. Exiting now.; exit" INT


# mt
# ==============================================================================
cd mt
# compute MTR in WM
sct_extract_metric -i mtr.nii.gz -l 51 -method map -o ../../mtr_in_WM.xls
# compute MTR in dorsal columns
sct_extract_metric -i mtr.nii.gz -l 53 -method map -o ../../mtr_in_DC.xls
# compute FA in lateral funiculi
sct_extract_metric -i mtr.nii.gz -l 54 -method map -o ../../mtr_in_LF.xls
# compute MTR in WM at C3-C4 levels and average per level
sct_extract_metric -i mtr.nii.gz -l 51 -method map -vert 3:4 -perlevel 1 -o ../../mtr_in_WM_C3-C4.xls
# compute MTR in WM between slices 5 and 15 and averaged across slices
sct_extract_metric -i mtr.nii.gz -l 51 -method map -z 5:15 -perslice 0 -o ../../mtr_in_WM_z5-15.xls
cd ..
