#!/bin/bash
i=1                                                                                                                    
IS_THROUGHPUT_TEST=${!i}; i=$((i+1))
CMSSW_VER=${!i}; i=$((i+1))
OUTDIR=${!i}; i=$((i+1))
THREADS=${!i}; i=$((i+1))
FILES="${@:$i}"

export SCRAM_ARCH=slc7_amd64_gcc900
source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p CMSSW_11_3_0
cd CMSSW_11_3_0
eval `scramv1 runtime -sh`

cd ..

pwd
ls

source /cvmfs/cms.cern.ch/cmsset_default.sh
tar -xf "${CMSSW_VER}_${OUTDIR}.tgz"
rm "${CMSSW_VER}_${OUTDIR}.tgz"
ls
cd ${CMSSW_VER}/src/sonic-workflows

pwd

#rm step2_PAT.py
#xrdcp -s root://cmseos.fnal.gov//store/user/wmccorma/step2_PAT_local.py ./step2_PAT.py

scramv1 b -r ProjectRename # this handles linking the already compiled code - do NOT recompile                                             
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers                                                                      

echo $CMSSW_BASE "is the CMSSW we have on the local worker node"

#cmsenv                                                                                                                                 
max_events_to_process=0
splitfiles=($FILES)
if [[ $IS_THROUGHPUT_TEST == 0 ]]
then
    echo "executing throughput test..." 
    #xrdcp ${FILES} .
    splitfiles=($FILES)
    for f in "${splitfiles[@]}"
    do
	echo 'root://cmsxrootd.fnal.gov/'${f}' .'
	condor_chirp ulog "xrdcp root://cmsxrootd.fnal.gov/${f} ."
        xrdcp root://cmsxrootd.fnal.gov/${f} .
    done
    max_events_to_process="100"
else
    echo "executing miniaod processing..."
    IFS=" "
    splitfiles=($FILES)
    unset IFS
    for f in "${splitfiles[@]}"
    do
	echo 'root://cmsxrootd.fnal.gov/${f} .'
        xrdcp root://cmsxrootd.fnal.gov/${f} .
    done 
    max_events_to_process="-1"
fi

ls -ltrh 


#cmsRun run.py address="35.224.243.148" tmi=True threads=${THREADS} maxEvents=1
echo ${FILES}
for f in "${splitfiles[@]}"
do
    echo 'the file:'
    echo $f
    echo $f >> file_of_files.txt
done

ls

echo 'about to head the file'
head file_of_files.txt
echo 'headed the file'
echo ${THREADS}
cmsRun run_files.py address="35.224.243.148" tmi=True threads=${THREADS} maxEvents=1
#condor_chirp ulog "test 6"

sleep 60

condor_chirp set_job_attr READY '"True"'

while true
do
    condor_chirp ulog "Hello in while loop"
    GO=`condor_chirp get_job_attr GO`
    condor_chirp ulog ${GO}
    if [ "$GO" == '"TRUE"' ]
    then
	condor_chirp ulog "Hello World"
	break
    fi
    sleep 15
done

condor_chirp ulog "Starting"
condor_chirp ulog "cmsRun run_files.py address=\"35.224.243.148\" tmi=True threads=${THREADS} maxEvents=${max_events_to_process}"
cmsRun run_files.py address="35.224.243.148" tmi=True threads=${THREADS} maxEvents=${max_events_to_process}

condor_chirp set_job_attr DONEJOB '"True"'
