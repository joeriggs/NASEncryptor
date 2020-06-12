#!/bin/bash

################################################################################
# This is the build tool for the NAS Encryptor.
#
# Output:
#   0 - success.
#   1 - failure.
################################################################################

export TOP_DIR=$( cd `dirname ${0}` && echo ${PWD} )

echo "NAS Encryptor: This is the build script." &> /dev/stderr

${TOP_DIR}/PKG/buildPKG.sh
RC=$?

exit ${RC}

