#!/bin/bash

####################
# Get the names of the files that we need to install.

echo -n "Get the name of the tinyxml RPM file ... "
TINYXML_RPM_FILE=`find . -maxdepth 1 -name tinyxml2-*.el8.x86_64.rpm`
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass (${TINYXML_RPM_FILE})."

echo -n "Get the name of the EncFS RPM file ... "
ENCFS_RPM_FILE=`find . -maxdepth 1 -name fuse-encfs-*.el8.x86_64.rpm`
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass (${ENCFS_RPM_FILE})."

echo -n "Get the name of the NAS Encryptor RPM file ... "
NAS_ENCRYPTOR_RPM_FILE=`find . -maxdepth 1 -name NAS_Encryptor*.x86_64.rpm`
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass (${NAS_ENCRYPTOR_RPM_FILE})."

####################
# Now install the files.

echo -n "Install ${TINYXML_RPM_FILE} ... "
rpm -ihv ${TINYXML_RPM_FILE}
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass."

echo -n "Install ${ENCFS_RPM_FILE} ... "
rpm -ihv ${ENCFS_RPM_FILE}
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass."

echo -n "Install ${NAS_ENCRYPTOR_RPM_FILE} ... "
rpm -ihv ${NAS_ENCRYPTOR_RPM_FILE}
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass."

####################
# Done.  Successful installation!
echo "NAS Encryptor Installation complete."
exit 0
