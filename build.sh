#!/bin/bash

################################################################################
# This is the build tool for the NAS Encryptor.
#
# Output:
#   0 - success.
#   1 - failure.
################################################################################

export TOP_DIR=$( cd `dirname ${0}` && echo ${PWD} )

${TOP_DIR}/PKG/buildPKG.sh
RC=$?

exit ${RC}

