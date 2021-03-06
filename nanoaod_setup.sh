#!/bin/bash
export SCRAM_ARCH=slc7_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_6_0_patch2/src ] ; then
    echo release CMSSW_10_6_0_patch2 already exists
else
    scram p CMSSW CMSSW_10_6_0_patch2
fi
cd CMSSW_10_6_0_patch2/src
eval `scram runtime -sh`


scram b
cd ../../
cmsDriver.py \
    --filein file:miniaod.root \
    --fileout file:nanoaod.root \
    --mc --eventcontent NANOAODSIM \
    --nThreads 8 \
    --datatier NANOAODSIM --conditions 106X_upgrade2023_realistic_v3 --step NANO \
    --geometry Extended2023D41 --era Phase2C8_timing_layer_bar \
    --python_filename nanoaod_cfg.py \
    --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 100 \
    || exit $? ;
