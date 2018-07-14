# multiparametric-fixed-fov
Processing pipeline (multi-subjects) for processing multi-parametric data when
FOV is systematically centered at a particular vertebral level. This prior
knowledge prevents us from having to rely on an anatomical data, which is
typically used for intermediate registration to the template (following
  vertebral labeling). Here, template registration can be done directly to the
multiparametric data.

The following metrics are output (per contrast):
- dmri: FA, MD, etc. in whole WM and sub-tracts, averaged across slices
- mt: MTR in WM in whole WM and sub-tracts, averaged across slices
- mt: MTsat in whole WM and sub-tracts, averaged across slices

## Dependencies

This pipeline was tested on [SCT v3.2.3](https://github.com/neuropoly/spinalcordtoolbox/releases/tag/v3.2.3).
This pipeline relies on [FSLeyes](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSLeyes) for active QC.

## File structure

~~~
data
  |- 001
  |- 002
  |- 003
      |- mt
        |- mt1.nii.gz
        |- mt0.nii.gz
        |- t1w.nii.gz
      |- dmri
        |- dmri.nii.gz
        |- bvecs.txt
        |- bvals.txt
~~~

## How to run

- Organize your data as indicated above
- Download (or `git clone`) this repository.
- Go to this repository: `cd multiparametric-fixed-fov`
- Export environment variable: ``` export PATH_SCT_PIPELINE=`pwd` ```
- Go to the main `data` folder
- Process data: `${PATH_SCT_PIPELINE}/process_data.sh`
- Compute metrics: `${PATH_SCT_PIPELINE}/extract_metrics.sh`

## Contributors

Julien Cohen-Adad
