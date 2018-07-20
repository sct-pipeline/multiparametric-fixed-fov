#!/bin/bash
# Configuration file for your study.
# Copy this file and rename it as `parameters.sh`, then modify the variables
# according to your needs.

# Path to input data (do not add "/" at the end). This path should be absolute
# (i.e. should start with "/"). Example: PATH_DATA="/Users/bob/data"
export PATH_DATA=""

# List of subjects to analyse. If you want to analyze all subjects in the
# PATH_DATA folder, then comment this variable.
export SUBJECTS=(
	"001"
	"002"
	)

# Vertebral or disc level where FOV is centered. Uncomment the appropriate
# variable and assign value:
# export MIDFOV_DISC=X
# export MIDFOV_VERT=

# Vertebral levels to compute MRI metrics from. Please replace the example
# values below.
export METRICS_VERT_LEVEL="3,4,5"

# Path where to save results (do not add "/" at the end).
export PATH_RESULTS="${PATH_DATA}/results"
