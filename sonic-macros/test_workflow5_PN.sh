#!/bin/bash                                                                                                                             
set -x
echo "pwd"
pwd
echo "ls"
ls

# Sleep                                                                                                                                 
#sleep $1                                                                                                                               
#echo "##### HOST DETAILS #####"                                                                                                        
#echo "I slept for $1 seconds on:"                                                                                                      
#wget https://raw.githubusercontent.com/fastmachinelearning/sonic-workflows/master/setup.sh                                             
#chmod +x setup.sh                                                                                                                      
#./setup.sh                                                                                                                             
#cd CMSSW_12_0_0_pre5/src                                                                                                               
#git cms-addpkg Configuration/ProcessModifiers                                                                                          
#git cms-merge-topic kpedro88:TritonMiniAODModifiers                                                                                    
#cd sonic-workflows                                                                                                                     

export SCRAM_ARCH=slc7_amd64_gcc900
source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p CMSSW_11_3_0
cd CMSSW_11_3_0
eval `scramv1 runtime -sh`

cd ..
xrdcp -s root://cmseos.fnal.gov//store/user/wmccorma/CMSSW_12_0_0_pre5.tgz .
source /cvmfs/cms.cern.ch/cmsset_default.sh
tar -xf CMSSW_12_0_0_pre5.tgz
rm CMSSW_12_0_0_pre5.tgz
cd CMSSW_12_0_0_pre5/src/sonic-workflows
echo "pwd where am i"
pwd
echo "ls what's here"
ls
echo "ls .."
ls ..

#cmsenv                                                                                                                                 

xrdcp root://cmsxrootd.fnal.gov//store/relval/CMSSW_10_6_4/RelValProdTTbar_13_pmx25ns/AODSIM/PUpmx25ns_106X_upgrade2018_realistic_v9-v1/10000/4440FA53-897B-9A4B-AD76-D1337B591A2F.root .
xrdcp root://cmsxrootd.fnal.gov//store/relval/CMSSW_10_6_4/RelValProdTTbar_13_pmx25ns/AODSIM/PUpmx25ns_106X_upgrade2018_realistic_v9-v1/10000/457C377A-809A-1947-A600-27720ED415FB.root .
xrdcp root://cmsxrootd.fnal.gov//store/relval/CMSSW_10_6_4/RelValProdTTbar_13_pmx25ns/AODSIM/PUpmx25ns_106X_upgrade2018_realistic_v9-v1/10000/655A4F07-F40C-324A-8EC0-B19A7F03893F.root .

rm step2_PAT.py
xrdcp -s root://cmseos.fnal.gov//store/user/wmccorma/step2_PAT_local.py ./step2_PAT.py

rm ../Configuration/ProcessModifiers/python/allSonicTriton_cff.py
xrdcp -s root://cmseos.fnal.gov//store/user/wmccorma/allSonicTriton_PN_cff.py ../Configuration/ProcessModifiers/python/allSonicTriton_cff.py

scramv1 b -r ProjectRename # this handles linking the already compiled code - do NOT recompile                                             
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers                                                                      

echo $CMSSW_BASE "is the CMSSW we have on the local worker node"
#cd ${_CONDOR_SCRATCH_DIR}                                                                                                              

#cmsRun run.py address="ailab01.fnal.gov" tmi=True port=9001 ssl=True threads=4
#cmsRun run.py maxEvents=100 address="35.224.243.148" tmi=True
cmsRun run.py address="35.224.243.148" tmi=True threads=4 maxEvents=1
sleep 60
cmsRun run.py address="35.224.243.148" tmi=True threads=4
#cmsRun run.py maxEvents=100 sonic=False tmi=True threads=4
#cmsRun run.py sonic=False tmi=True threads=4
#cmsRun run.py maxEvents=100 sonic=False tmi=True threads=4


echo "ls"
ls

echo "pwd"
pwd

hostname
date
