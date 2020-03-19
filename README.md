# mctrack
Instructions to generate MC for (HLT) tracking work within the
[CMSSW](https://github.com/cms-sw/cmssw) framework.

Configs to generate each step of the MC chain can be found at
[MCM](https://cms-pdmv.cern.ch/mcm/) by navigating through
`requests > Navigation` and searching for the relevant sample. Generation of
the ttbar for the 14 TeV HL-LHC upgrade will be included here as the stress
test of the tracking algorithm.

The various steps of generation are detailed below. Each step includes a setup
bash script run using `sh <step>_setup.sh` which creates the CMSSW working area
as well a the python config file run using `cmsRun <step>_cfg.py`.


## LHE

The LHE step involves three main sub-steps: lhe, gen, sim. The lhe and gen steps
run the matrix element calculations, particle decay, hadronization and
showering, which is subsequently stored in the
[LHE format](https://arxiv.org/abs/hep-ph/0609017); the sim step involves the
simulation of the CMS detector's response to the generated particles. This step
creates an output `lhe.root` file with a temporary `lhe_inLHE.root` file.
