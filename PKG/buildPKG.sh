#!/bin/bash

################################################################################
# Build the package that holds the extensions for turning a NAS Proxy into a
# NAS Encryptor.  You can run this script yourself, but it's intended to be
# run by the build tools in the NASProxy project.
#
# The result of running this script will be a file called nasenc.tar.  That file
# will contain all of the pieces necessary for the NAS Encryptor to run, and it
# will include a file called /installNASEncryptor.sh that will contain all of
# the logic necessary to install the NAS Encryptor into a NAS Proxy VM.
#
# Output:
#    0 - success.
#    1 - failure.
################################################################################

readonly BLD_DIR=$( cd `dirname ${0}`    && echo ${PWD} )
readonly TOP_DIR=$( cd ${BLD_DIR}/..     && echo ${PWD} )

# The RPM spec file uses this environment variable.
export TOP_DIR

# This is the final product.  It's eventually going to get copied to a CD/DVD
# ISO file, so make sure it conforms to the 8.3 filename convention.
readonly PKG_FILE=${BLD_DIR}/nasenc.tar

################################################################################
# Log a message.
#
# Input:
#   MSG is the message to log.
#
#   DO_NL = 1 to include a newline at the end of the message.
#
# Output:
#   The message is written to stdout.
################################################################################
logMessage() {
	local MSG="${1}"
	local DO_NL=${2}

	if [ ${DO_NL} -eq 1 ]; then
		printf "%s\n" "${MSG}"
	else
		printf "%s"   "${MSG}"
	fi
}

logMessage "Building the NAS Encryptor Package:" 1

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

# CD to the build directory.  This script can (and probably will) get called
# from a different location, so we need to hop over to our own directory before
# we start building the NAS Encryptor package.
logMessage "  CD to build dir ... " 0
cd ${BLD_DIR} &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

# Delete any existing RPM files.  We want to start with a blank canvas.
logMessage "  Delete old RPM files ... " 0
rm -f *.rpm &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

# Delete any old package files.  Blank canvas!
logMessage "  Delete the old package file ... " 0
rm -f ${PKG_FILE} &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

logMessage "" 1

########################################
# Download the packages that are required for ecryptfs.  Some of them aren't
# part of the standard Fedora 32 distribution, so we need to get them now.
logMessage "Download required packages:" 1

logMessage "  pkcs11-helper-devel ... " 0
sudo yum install -y --enablerepo=fedora --downloadonly --downloaddir=${BLD_DIR} pkcs11-helper-devel &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

logMessage "  trousers-devel ... " 0
sudo yum install -y --enablerepo=fedora --downloadonly --downloaddir=${BLD_DIR} trousers-devel &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

logMessage "  ecryptfs-utils ... " 0
sudo yum install -y --enablerepo=fedora --downloadonly --downloaddir=${BLD_DIR} ecryptfs-utils &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

logMessage "  Verify ecryptfs-utils RPM file ... " 0
[ ! -f ecryptfs-utils-*.fc32.x86_64.rpm ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

logMessage "" 1

########################################
# Build the NAS Encryptor RPM.
logMessage "Build the RPM:" 1

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

# Delete the rpmbuild directory.
logMessage "  Delete the rpmbuild directory ... " 0
rm -rf ${RPMBUILD_DIR} &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

logMessage "" 1

########################################
# Build the package.
logMessage "Build the package:" 1

# Build it.
logMessage "  Run tar to create the file ... " 0
tar cf ${PKG_FILE} installNASEncryptor.sh *.rpm &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

# Delete all of the RPM files.  This cleans up our mess.
logMessage "  Delete old RPM files ... " 0
rm -f *.rpm &> ${LOG}
[ $? -ne 0 ] && logMessage "Fail." 1 && exit 1 ; logMessage "Pass." 1

logMessage "" 1

########################################
logMessage "  `basename ${0}` Success." 1
exit 0

