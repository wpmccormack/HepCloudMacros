#!/bin/bash

CLUSTER=$1
CLIENTS=$(condor_q ${CLUSTER} -af READY | wc | awk {'print $1'})

while true
do
    NCLIENTS_RUNNING=$(condor_q ${CLUSTER} -af READY | grep True | wc | awk {'print $1'})
    if [[ ${CLIENTS} == ${NCLIENTS_RUNNING} ]]
    then
	condor_qedit ${CLUSTER} GO '"TRUE"'
	break
    fi
    sleep 30
done
