#!/bin/bash
#
# Process data
#
# Author: Julien Cohen-Adad

# EDIT THE VARIABLE BELOW WITH YOUR SETTINGS:
# ==============================================================================
# Value of the inter-vertebral disc in the middle of the FOV in the Superior-Inferior direction.
# Convention for disc value is: C2/C3 -> 3, C3/C4 -> 4, etc.
DISC_MIDFOV="4"
# ==============================================================================

# Build color coding (cosmetic stuff)
Color_Off='\033[0m'       # Text Reset
Green='\033[0;92m'       # Yellow
On_Black='\033[40m'       # Black

# mt
# ==============================================================================
cd mt
# Check if manual segmentation already exists
if [ -e "t1w_seg_manual.nii.gz" ]; then
  file_seg="t1w_seg_manual.nii.gz"
else
  # Segment cord
  sct_propseg -i t1w.nii.gz -c t1
  file_seg="t1w_seg.nii.gz"
  # Check segmentation results and do manual corrections if necessary, then save modified segmentation
  printf "${Green}${On_Black}\nFSLeyes window will now open. Check the segmentation and do manual correction if necessary, then save the modified segmentation as t1w_seg_manual.nii.gz and close FSLeyes window.\n. Press any key to continue...${Color_Off}"
  read -p ""
  fsleyes t1w.nii.gz -cm greyscale t1w_seg.nii.gz -cm red -a 70.0 &
  # pause process during checking
  printf "${Green}${On_Black}\nWhen you are done checking/fixing the segmentation, press any key to continue...\n${Color_Off}"
  read -p ""
  # check if segmentation was modified
  if [ -e "t1w_seg_manual.nii.gz" ]; then
  	file_seg="t1w_seg_manual.nii.gz"
  fi
fi
# Create mask
sct_create_mask -i t1w.nii.gz -p centerline,${file_seg} -size 35mm
# Crop data for faster processing
sct_crop_image -i t1w.nii.gz -m mask_t1w.nii.gz -o t1w_crop.nii.gz
# Register mt0->t1w
# Tips: here we only use rigid transformation because both images have very similar sequence parameters. We don't want to use SyN/BSplineSyN to avoid introducing spurious deformations.
sct_register_multimodal -i mt0.nii.gz -d t1w_crop.nii.gz -param step=1,type=im,algo=rigid,slicewise=1,metric=CC -x spline
# Register mt1->t1w
sct_register_multimodal -i mt1.nii.gz -d t1w_crop.nii.gz -param step=1,type=im,algo=rigid,slicewise=1,metric=CC -x spline
# create disc label in the middle of the S-I direction at the center of the cord
sct_label_utils -i t1w_crop.nii.gz -create-seg -1,$DISC_MIDFOV -o label_disc.nii.gz
# Register template->t1w
sct_register_to_template -i t1w_crop.nii.gz -s ${file_seg} -ldisc label_disc.nii.gz -ref subject -c t1 -param step=1,type=seg,algo=centermass:step=2,type=seg,algo=bsplinesyn,slicewise=1,iter=3
# Rename warping field for clarity
mv warp_template2anat.nii.gz warp_template2mt.nii.gz
# Warp template
sct_warp_template -d t1w_crop.nii.gz -w warp_template2mt.nii.gz
# Compute MTR
sct_compute_mtr -mt0 mt0_reg.nii.gz -mt1 mt1_reg.nii.gz
# Go back to parent folder
cd ..