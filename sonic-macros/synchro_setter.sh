#!/bin/bash

CLUSTER=$1
QUEUE=$2

i=0
while [ "$i" -lt "$2" ]
do
    echo ${CLUSTER}.${i}
    #condor_q ${CLUSTER} -af READY
    condor_q ${CLUSTER}.${i} -af READY
    TEST=`condor_q ${CLUSTER}.${i} -af READY`
    #TEST=`condor_q ${CLUSTER}.${i} -af READY`
    #echo "$TEST"
    if [ "$TEST" == 'True' ]
    then
	#echo 'moving on'
	i=$((i + 1))
    fi
done

condor_qedit ${CLUSTER} GO '"TRUE"'
