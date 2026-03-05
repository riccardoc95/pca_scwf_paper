#!/usr/bin/env bash
set -euo pipefail

conda create -n apptainer -c conda-forge apptainer
conda env create -f envs/rapid_singlecell_capri.yml
conda activate apptainer

apptainer build --fakeroot envs/bioc_2_20_pca_wfsc.sif envs/bioc_2_20_pca_wfsc.def
