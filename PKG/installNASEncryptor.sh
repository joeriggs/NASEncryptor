#!/bin/bash

####################
# Get the names of the files that we need to install.

echo -n "Get the name of the pkcs11-helper RPM file ... "
PKCS11_HELPER_RPM_FILE=`find . -maxdepth 1 -name pkcs11-helper-*.x86_64.rpm`
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass (${PKCS11_HELPER_RPM_FILE})."

echo -n "Get the name of the ecryptfs-utils RPM file ... "
ECRYPTFS_RPM_FILE=`find . -maxdepth 1 -name ecryptfs-utils-*.x86_64.rpm`
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass (${ECRYPTFS_RPM_FILE})."

echo -n "Get the name of the NAS Encryptor RPM file ... "
NAS_ENCRYPTOR_RPM_FILE=`find . -maxdepth 1 -name NAS_Encryptor*.x86_64.rpm`
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass (${NAS_ENCRYPTOR_RPM_FILE})."

####################
# Now install the files.

echo -n "Install ${PKCS11_HELPER_RPM_FILE} ... "
rpm -ihv ${PKCS11_HELPER_RPM_FILE}
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass."

echo -n "Install ${ECRYPTFS_RPM_FILE} ... "
yum install -y ${ECRYPTFS_RPM_FILE}
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

