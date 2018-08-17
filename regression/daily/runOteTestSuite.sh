#!/bin/bash -x
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
DAILYDIR="$GOPATH/src/github.com/hyperledger/fabric-test/regression/daily"
cd $DAILYDIR

echo "======== Orderer Performance tests...========"
py.test -v --junitxml results_orderer_ote.xml orderer_ote.py

copy_logs $? ote
# Create Logs directory
mkdir -p $WORKSPACE/Docker_Container_Logs
artifacts() {

    echo "---> Archiving generated logs"
    rm -rf $WORKSPACE/archives
    mkdir -p "$WORKSPACE/archives"
    mv "$WORKSPACE/Docker_Container_Logs" $WORKSPACE/archives/
}
# Capture docker logs of each container
logs() {

   cp *.log $WORKSPACE/LOGS/$1.log
   cp *.xml $WORKSPACE/LOGS/$1.xml
    echo

}

copy_logs() {

# Call logs function
logs $1

if [ $1 != 0 ]; then
    artifacts
    exit 1
fi
}
