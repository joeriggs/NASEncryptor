#!/bin/bash

################################################################################
# This is the build tool for the NAS Encryptor.
################################################################################

export TOP_DIR=$( cd `dirname ${0}` && echo ${PWD} )

echo "NAS Encryptor: This is the build script." &> /dev/stderr

${TOP_DIR}/RPM/buildRPM.sh
RC=$?

exit ${RC}

