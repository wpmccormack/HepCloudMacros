#!/bin/bash

CLUSTER=$1
QUEUE=$2


#i=0
#while [ "$i" -lt "$2" ]
#do
#    echo ${CLUSTER}.${i}
#    #condor_q ${CLUSTER} -af READY
#    condor_q ${CLUSTER}.${i} -af READY
#    TEST=`condor_q ${CLUSTER}.${i} -af READY`
#    #TEST=`condor_q ${CLUSTER}.${i} -af READY`
#    #echo "$TEST"
#    if [ "$TEST" == 'True' ]
#    then
#	#echo 'moving on'
#	i=$((i + 1))
#    fi
#done

#condor_qedit ${CLUSTER} GO '"TRUE"'
#
while true
do
    TEST=`condor_q ${CLUSTER}.0 -af GO`
    if [ "$TEST" == 'TRUE' ]
    then
	break
    fi
    sleep 60
done

while true
do
    TEST=`condor_q ${CLUSTER}.0 -af GO`
    echo ${TEST}
    if [ "$TEST" != 'TRUE' ]
    then
	break
    fi
    curl 35.224.243.148:8002/metrics
    sleep 60
done
