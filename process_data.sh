#!/bin/bash
#
# Process data
#
# Author: Julien Cohen-Adad

# dmri
# ===========================================================================================
cd dmri
# Separate b=0 and DW images
sct_dmri_separate_b0_and_dwi -i dmri.nii.gz -bvec bvecs.txt
# Segment cord (1st pass just to get the centerline)
sct_propseg -i dwi_mean.nii.gz -c dwi
# Create mask to aid in motion correction and for faster processing
sct_create_mask -i dwi_mean.nii.gz -p centerline,dwi_mean_seg.nii.gz -size 30mm
# Crop data for faster processing
sct_crop_image -i dmri.nii.gz -m mask_dwi_mean.nii.gz -o dmri_crop.nii.gz
# Motion correction
sct_dmri_moco -i dmri_crop.nii.gz -bvec bvecs.txt -x spline
# Check if manual segmentation already exists
if [ -e "dwi_moco_mean_seg_manual.nii.gz" ]; then
  file_seg="dwi_moco_mean_seg_manual.nii.gz"
else
  # Segment cord (2nd pass, after motion correction)
  sct_propseg -i dwi_moco_mean.nii.gz -c dwi
  file_seg="dwi_moco_mean_seg.nii.gz"
  # Check segmentation results and do manual corrections if necessary, then save modified segmentation as dwi_moco_mean_seg_manual.nii.gz"
  echo "Check segmentation and do manual correction if necessary, then save segmentation as dwi_moco_mean_seg_manual.nii.gz"
  fsleyes dwi_moco_mean.nii.gz -cm greyscale dwi_moco_mean_seg.nii.gz -cm red -a 70.0 &
  # pause process during checking
  read -p "Press any key to continue..."
  # check if segmentation was modified
  if [ -e "dwi_moco_mean_seg_manual.nii.gz" ]; then
  	file_seg="dwi_moco_mean_seg_manual.nii.gz"
  fi
fi
# Register template to dwi
# Tips: Only use segmentations.
# Tips: First step: slicereg based on images, with large smoothing to capture potential motion between anatomical and dmri.
# Tips: Second step: bpslinesyn in order to adapt the shape of the cord to the dmri modality (in case there are distortions between anatomical and dmri).
sct_register_to_template -i dwi_moco_mean.nii.gz -s ${file_seg} -ldisc ../t2/labels_disc.nii.gz -ref subject -c t1 -param step=1,type=seg,algo=centermass:step=2,type=seg,algo=bsplinesyn,slicewise=1,iter=3
# Rename warping field for clarity
mv warp_template2anat.nii.gz warp_template2dmri.nii.gz
# Warp template
sct_warp_template -d dwi_moco_mean.nii.gz -w warp_template2dmri.nii.gz
# Compute DTI
sct_dmri_compute_dti -i dmri_crop_moco.nii.gz -bvec bvecs.txt -bval bvals.txt
# Go back to parent folder
cd ..
#
#
# # mt
# # ===========================================================================================
# cd mt
# # Check if manual segmentation already exists
# if [ -e "t1w_seg_manual.nii.gz" ]; then
#   file_seg="t1w_seg_manual.nii.gz"
# else
#   # Segment cord (2nd pass, after motion correction)
#   sct_propseg -i t1w.nii.gz -c t1
#   file_seg="t1w_seg.nii.gz"
#   # Check segmentation results and do manual corrections if necessary, then save modified segmentation as dwi_moco_mean_seg_manual.nii.gz"
#   echo "Check segmentation and do manual correction if necessary, then save segmentation as t1w_seg_manual.nii.gz"
#   fsleyes t1w.nii.gz -cm greyscale t1w_seg.nii.gz -cm red -a 70.0 &
#   # pause process during checking
#   read -p "Press any key to continue..."
#   # check if segmentation was modified
#   if [ -e "t1w_seg_manual.nii.gz" ]; then
#   	file_seg="t1w_seg_manual.nii.gz"
#   fi
# fi
# # Create mask
# sct_create_mask -i t1w.nii.gz -p centerline,${file_seg} -size 35mm
# # Crop data for faster processing
# sct_crop_image -i t1w.nii.gz -m mask_t1w.nii.gz -o t1w_crop.nii.gz
# # Register mt0->t1w
# # Tips: here we only use rigid transformation because both images have very similar sequence parameters. We don't want to use SyN/BSplineSyN to avoid introducing spurious deformations.
# sct_register_multimodal -i mt0.nii.gz -d t1w_crop.nii.gz -param step=1,type=im,algo=rigid,slicewise=1,metric=CC -x spline
# # Register mt1->t1w
# sct_register_multimodal -i mt1.nii.gz -d t1w_crop.nii.gz -param step=1,type=im,algo=rigid,slicewise=1,metric=CC -x spline
# # create dummy label with value=4
# sct_label_utils -i t1w_crop.nii.gz -create 1,1,1,4 -o label_dummy.nii.gz
# # use dummy label to import labels from t1 and keep only value=4 label
# sct_label_utils -i ../t1/label_disc.nii.gz -remove label_dummy.nii.gz -o label_disc.nii.gz
# # Register template->t1w
# sct_register_to_template -i t1w_crop.nii.gz -s ${file_seg} -ldisc label_disc.nii.gz -ref subject -c t1 -param step=1,type=seg,algo=centermass:step=2,type=seg,algo=bsplinesyn,slicewise=1,iter=3
# # Rename warping field for clarity
# mv warp_template2anat.nii.gz warp_template2mt.nii.gz
# # Warp template
# sct_warp_template -d t1w_crop.nii.gz -w warp_template2mt.nii.gz
# # Compute MTR
# sct_compute_mtr -mt0 mt0_reg.nii.gz -mt1 mt1_reg.nii.gz
# # Compute MTsat
# # TODO
# # sct_compute_mtsat -mt mt1_crop.nii.gz -pd mt0_reg.nii.gz -t1 t1w_reg.nii.gz -trmt 30 -trpd 30 -trt1 15 -famt 9 -fapd 9 -fat1 15
# # Go back to parent folder
# cd ..
#
