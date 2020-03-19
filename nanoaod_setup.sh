#!/bin/bash
export SCRAM_ARCH=slc6_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_2_5/src ] ; then
    echo release CMSSW_10_2_5 already exists
else
    scram p CMSSW CMSSW_10_2_5
fi
cd CMSSW_10_2_5/src
eval `scram runtime -sh`


scram b
cd ../../
cmsDriver.py \
    --filein file:miniaod.root \
    --fileout file:nanoaod.root \
    --mc --eventcontent NANOEDMAODSIM \
    --datatier NANOAODSIM --conditions 106X_upgrade2023_realistic_v3 --step NANO \
    --nThreads 8 \
    --era Phase2C8_timing_layer_bar \
    --python_filename nanoaod_cfg.py \
    --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 100 \
    || exit $? ;
