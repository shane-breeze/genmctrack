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
    --filein file:lhe.root \
    --fileout file:fevt.root \
    --pileup_input "dbs:/MinBias_TuneCP5_14TeV-pythia8/PhaseIITDRSpring19GS-106X_upgrade2023_realistic_v2_ext1-v1/GEN-SIM" \
    --mc --eventcontent FEVTDEBUGHLT --pileup 'AVE_140_BX_25ns,{"B":(-3,3)}' \
    --customise SLHCUpgradeSimulations/Configuration/aging.customise_aging_1000,Configuration/DataProcessing/Utils.addMonitoring \
    --datatier GEN-SIM-DIGI-RAW --conditions 106X_upgrade2023_realistic_v3 --step DIGI:pdigi_valid,L1,L1TrackTrigger,DIGI2RAW,HLT:@fake2 \
    --nThreads 8 \
    --geometry Extended2023D41 --era Phase2C8_timing_layer_bar \
    --python_filename fevt_cfg.py \
    --no_exec -n 100 \
    || exit $? ;
