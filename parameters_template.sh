#!/bin/bash
# Configuration file for your study.
# Copy this file and rename it as `parameters.sh`, then modify the variables
# according to your needs.

# Path to working directory, which contains data results, qc, etc. (do not add "/" at the end). 
# This path should be absolute (i.e. should start with "/"). Example: PATH_DATA="/Users/bob/experiments"
export PATH_MAIN="/Users/julien/data/rainville_lumbar"

# Path to the folder which contains all data
export PATH_DATA="${PATH_MAIN}/data"

# List of subjects to analyse. If you want to analyze all subjects in the
# PATH_DATA folder, then comment this variable.
export SUBJECTS=(
	"slbp_001p"
	"SLBP_002"
	"slbp_004"
	"slbp_005"
	"slbp_006"
	)

# vertebral or disc level where FOV is centered. Uncomment the appropriate
# variable and assign value:
# export MIDFOV_DISC=X
# export MIDFOV_VERT=X

# Vertebral levels to compute MRI metrics from
export METRICS_VERT_LEVEL="3,4,5"

# Path where to save results (do not add "/" at the end).
export PATH_RESULTS="${PATH_MAIN}/results"

# Path where to save QC results (do not add "/" at the end).
export PATH_QC="${PATH_MAIN}/qc"
