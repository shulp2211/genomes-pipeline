#!/bin/bash

source /nfs/production/interpro/metagenomics/mags-scripts/annot-config
source /hps/nobackup2/production/metagenomics/pipeline/tools-v5/toil-user-env/bin/activate
export PATH=$PATH:/homes/emgpr/.nvm/versions/node/v12.10.0/bin/

export MEMORY=20G
export NUM_CORES=8

export WORK_DIR=/hps/nobackup2/production/metagenomics/pipeline/testing/kate_work
export OUT_DIR=/hps/nobackup2/production/metagenomics/pipeline/testing/kate_out
export PIPELINE_FOLDER=/hps/nobackup2/production/metagenomics/databases/human-gut_resource/cwl_pipeline/genomes-pipeline

export NAME_RUN=test-genomes
export CWL=$PIPELINE_FOLDER/workflows/wf.cwl
export YML=$PIPELINE_FOLDER/workflows/wf.yml

# < set up folders >
export JOB_TOIL_FOLDER=$WORK_DIR/$NAME_RUN/
export LOG_DIR=${OUT_DIR}/logs_${NAME_RUN}
export TMPDIR=${WORK_DIR}/global-temp-dir_${NAME_RUN}
export OUT_TOOL=${OUT_DIR}/${NAME_RUN}

mkdir -p $JOB_TOIL_FOLDER $LOG_DIR $TMPDIR $OUT_TOOL && \
cd $WORK_DIR && \
rm -rf $JOB_TOIL_FOLDER $OUT_TOOL/* $LOG_DIR/* && \
time cwltoil \
  --no-container \
  --batchSystem LSF \
  --disableCaching \
  --defaultMemory $MEMORY \
  --jobStore $JOB_TOIL_FOLDER \
  --outdir $OUT_TOOL \
  --logFile $LOG_DIR/${NAME_RUN}.log \
  --defaultCores $NUM_CORES \
$CWL $YML
