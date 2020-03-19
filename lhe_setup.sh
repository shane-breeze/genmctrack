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

curl -s --insecure https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_fragment/TSG-PhaseIITDRSpring19wmLHEGS-00030 --retry 2 --create-dirs -o Configuration/GenProduction/python/TSG-PhaseIITDRSpring19wmLHEGS-00030-fragment.py
[ -s Configuration/GenProduction/python/TSG-PhaseIITDRSpring19wmLHEGS-00030-fragment.py ] || exit $?;

scram b
cd ../../
seed=$(($(date +%s) % 100 + 1))
cmsDriver.py Configuration/GenProduction/python/TSG-PhaseIITDRSpring19wmLHEGS-00030-fragment.py \
    --fileout file:lhe.root \
    --mc --eventcontent RAWSIM,LHE \
    --customise SLHCUpgradeSimulations/Configuration/aging.customise_aging_1000,Configuration/DataProcessing/Utils.addMonitoring \
    --datatier GEN-SIM,LHE --conditions 106X_upgrade2023_realistic_v2 --beamspot HLLHC14TeV --step LHE,GEN,SIM \
    --nThreads 8 \
    --geometry Extended2023D41 --era Phase2C8_timing_layer_bar \
    --python_filename lhe_cfg.py \
    --no_exec \
    --customise_commands process.RandomNumberGeneratorService.externalLHEProducer.initialSeed="int(${seed})" \
    -n 100 \
    || exit $? ;
