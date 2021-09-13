#!/bin/bash                                                                                                                                                                                            

CLUSTER=$1
NCLIENTS_TOTAL=$(ls batch_logs | grep ${CLUSTER} | grep stderr | wc | awk {'print $1'})

i=0
while [ "$i" -lt ${NCLIENTS_TOTAL} ]
do
    python3 timeDiff.py batch_logs/testSyncroAILAB_${1}_${i}.stderr
    i=$((i + 1))
done

#for i in {0..9}
#do
#    python3 timeDiff.py batch_logs/testSyncro_805_${i}.stderr
#done
