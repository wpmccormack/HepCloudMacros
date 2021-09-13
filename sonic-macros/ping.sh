#!/bin/bash                                                                                                                             
set -x
echo "pwd"
pwd
echo "ls"
ls

#ping -c 10 35.224.243.148
curl 35.224.243.148:8002/metrics

hostname
date
