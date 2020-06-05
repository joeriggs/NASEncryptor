#!/bin/bash

################################################################################
# Build the RPM file that holds the entensions to turn a NAS Proxy into a
# NAS Encryptor.  You can run this script yourself, but it's intended to be
# run by the build tools in the NASProxy project.
#
# We return 2 values:
# 1. We "echo" the full pathname of the RPM file that contains the NAS Encryptor
#    RPM files.  So with this thought in mind, the script has to be silent WRT
#    communicating with the user.  Any messages that it wishes to display must
#    be written to stderr, because the RPM file pathname will be echoed to
#    stdout.
#
# 2. We "return" a pass/fail return code.
#    0 - success.
#    1 - failure.
################################################################################

readonly BLD_DIR=$( cd `dirname ${0}`    && echo ${PWD} )
readonly TOP_DIR=$( cd ${BLD_DIR}/..     && echo ${PWD} )
export TOP_DIR

################################################################################
# Log a message.
#
# Input:
#   MSG is the message to log.
#
#   DO_NL = 1 to include a newline at the end of the message.
#
# Output:
#   The message is written to stderr.
################################################################################
logMessage() {
	local MSG="${1}"
	local DO_NL=${2}

	if [ ${DO_NL} -eq 1 ]; then
		printf "%s\n" "${MSG}" &> /dev/stderr
	else
		printf "%s"   "${MSG}" &> /dev/stderr
	fi
}

logMessage "Building the NAS Encryptor RPM file:" 1

########################################
# Initialize some stuff before we start building.
logMessage "  Initialization:" 1

readonly LOG=/tmp/`basename ${0}`.log
logMessage "    Initialize log file (${LOG}) ... " 0
rm -f ${LOG} &> /dev/null
[ $? -ne 0 ] && logMessage "Unable to delete old log file." 1   && exit 1
touch ${LOG} &> /dev/null
[ $? -ne 0 ] && logMessage "Unable to create empty log file." 1 && exit 1
logMessage "Pass." 1

logMessage "" 1

########################################
# Build the RPM.
logMessage "Build the RPM:" 1

# CD to the build directory.
logMessage "  CD to build dir ... " 0
cd ${BLD_DIR} &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

# Delete any existing RPM files.
logMessage "  Delete old RPM files ... " 0
rm -f *.rpm &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

# Build the RPM right here!
readonly RPMBUILD_DIR=${BLD_DIR}/rpmbuild
logMessage "  Set rpmbuild dir to the current dir ... " 0
echo "%_topdir ${RPMBUILD_DIR}" > ~/.rpmmacros
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

# Start with a clean rpmbuild directory.
logMessage "  Clean out the rpmbuild directory ... " 0
rm -rf ${RPMBUILD_DIR} &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

# Initialize the rpmbuild directory ... "
logMessage "  Initialize the rpmbuild directory ... " 0
rpmdev-setuptree &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

# Build the NAS Encryptor RPM.
logMessage "  Build the NAS Encryptor RPM file ... " 0
rpmbuild -vv -ba NASEncryptor.spec &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

# Move the RPM file out of the rpmbuild area.
logMessage "  Extract RPM file ... " 0
mv ${RPMBUILD_DIR}/RPMS/x86_64/*.rpm . &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

# Get the name of the RPM file.  We need to "echo" it so that the NAS Proxy
# build script can receive it.
logMessage "  Get RPM file name ... " 0
RPM_PATH_NAME="${BLD_DIR}/`find . -maxdepth 1 -name *.rpm`"
logMessage "Done (${RPM_PATH_NAME})." 1

logMessage "" 1

########################################
logMessage "`basename ${0}` Success." 1
echo "${RPM_PATH_NAME}"
exit 0

