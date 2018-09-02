#!/bin/bash
#
# Process data
#
# Author: Julien Cohen-Adad

# Build color coding (cosmetic stuff)
Color_Off='\033[0m'
Green='\033[0;92m'
Red='\033[0;91m'
On_Black='\033[40m'

# mt
# ==============================================================================
cd mt
# Check if manual segmentation already exists
if [ -e "mt1_seg_manual.nii.gz" ]; then
  file_seg="mt1_seg_manual.nii.gz"
else
  # Segment cord
  sct_propseg -i mt1.nii.gz -c t2
  # sct_deepseg_sc -i mt1.nii.gz -c t2s  # alternative algorithm if propseg does not work well
  file_seg="mt1_seg.nii.gz"
  # Check segmentation results and do manual corrections if necessary
  fsleyes mt1.nii.gz -cm greyscale mt1_seg.nii.gz -cm red -a 70.0 &
  printf "${Green}${On_Black}\nFSLeyes will now open. Check the segmentation. If necessary, manually adjust the segmentation and then save it as: mt1_seg_manual.nii.gz. Close FSLeyes when you're finished, go back to the Terminal and press any key to continue...${Color_Off}"
  read -p ""
  # check if segmentation was modified
  if [ -e "mt1_seg_manual.nii.gz" ]; then
  	file_seg="mt1_seg_manual.nii.gz"
  fi
fi
# Create mask
sct_create_mask -i mt1.nii.gz -p centerline,${file_seg} -size 35mm
# Crop data for faster processing
sct_crop_image -i mt1.nii.gz -m mask_mt1.nii.gz -o mt1_crop.nii.gz
# Register mt0->mt1
# Tips: here we only use rigid transformation because both images have very similar sequence parameters. We don't want to use SyN/BSplineSyN to avoid introducing spurious deformations.
sct_register_multimodal -i mt0.nii.gz -d mt1_crop.nii.gz -param step=1,type=im,algo=rigid,slicewise=1,metric=CC -x spline
# Register mt1->t1w
sct_register_multimodal -i t1w.nii.gz -d mt1_crop.nii.gz -param step=1,type=im,algo=rigid,slicewise=1,metric=CC -x spline
# Two scenarii depending if the FOV is centered at a disc or mid-vertebral body
if [ ! -z ${MIDFOV_DISC} ]; then
  # create disc label in the middle of the S-I direction at the center of the cord
  sct_label_utils -i mt1_crop.nii.gz -create-seg -1,$MIDFOV_DISC -o label_disc.nii.gz
  # Register template->mt1
  sct_register_to_template -i mt1_crop.nii.gz -s ${file_seg} -ldisc label_disc.nii.gz -ref subject -c t2 -param step=1,type=seg,algo=centermass:step=2,type=im,algo=syn,metric=CC,slicewise=0,smooth=0,iter=3 -qc ../../../qc
elif [ ! -z ${MIDFOV_VERT} ]; then
  # create vert label in the middle of the S-I direction at the center of the cord
  sct_label_utils -i mt1_crop.nii.gz -create-seg -1,$MIDFOV_VERT -o label_vert.nii.gz
  # Register template->mt1
  sct_register_to_template -i mt1_crop.nii.gz -s ${file_seg} -l label_vert.nii.gz -ref subject -c t2 -param step=1,type=seg,algo=centermass:step=2,type=im,algo=syn,metric=CC,slicewise=0,smooth=0,iter=3 -qc ../../../qc
else
  printf "${Red}${On_Black}\nERROR: Neither MIDFOV_DISC nor MIDFOV_VERT field is active. Please see README.md. Exiting.\n\n${Color_Off}"
  exit 1
fi
# Rename warping field for clarity
mv warp_template2anat.nii.gz warp_template2mt.nii.gz
# Warp template
sct_warp_template -d mt1_crop.nii.gz -w warp_template2mt.nii.gz
# Compute MTR
sct_compute_mtr -mt0 mt0_reg.nii.gz -mt1 mt1_crop.nii.gz
# Go back to parent folder
cd ..
