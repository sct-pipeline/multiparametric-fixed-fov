# multiparametric-fixed-fov
Processing pipeline (multi-subjects) for processing multi-parametric data when
FOV is systematically centered at a particular vertebral level. This prior
knowledge prevents us from having to rely on an anatomical data, which is
typically used for intermediate registration to the template (following
  vertebral labeling). Here, template registration can be done directly to the
multiparametric data.

This pipeline will loop across all subjects located under the DATA folder and
results will be concatenated into single csv files (each row will correspond to
  a subject).

The following metric is output:
- **mt**: MTR in WM in whole WM and sub-tracts, averaged across slices

In future versions of this pipeline, the following example metrics will be added:
- **dmri**: FA, MD, etc. in whole WM and sub-tracts, averaged across slices
- **mt**: MTsat in whole WM and sub-tracts, averaged across slices

## Dependencies

This pipeline was tested on [SCT v3.2.3](https://github.com/neuropoly/spinalcordtoolbox/releases/tag/v3.2.3).
This pipeline relies on [FSLeyes](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSLeyes) for active QC.

## File structure

~~~
DATA
  |- 001
  |- 002
  |- 003
      |- mt
        |- mt1.nii.gz
        |- mt0.nii.gz
        |- t1w.nii.gz
~~~

## How to run

- Organize your data as indicated above
- Download (or `git clone`) this repository.
- Go to the repository folder: `cd multiparametric-fixed-fov`
- Edit the file `1_process_data.sh` and modify the variable `DISC_MIDFOV`
according to your needs. For example, if the MRI volume is centered at the
C5-C6 disc, then change the current value from `4` to `6`.
- Process data: `./run_process.sh 1_process_data.sh PATH_TO_DATA`
- Compute metrics: `./run_process.sh 2_extract_metrics.sh PATH_TO_DATA`

## Contributors

Julien Cohen-Adad
