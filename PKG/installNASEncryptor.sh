#!/bin/bash

####################
# Get the names of the file(s) that we need to install.
echo -n "Get the name of the NAS Encryptor RPM file ... "
NAS_ENCRYPTOR_RPM_FILE=`find . -maxdepth 1 -name NAS_Encryptor*.x86_64.rpm`
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass (${NAS_ENCRYPTOR_RPM_FILE})."

####################
# Now install the file(s).
echo -n "Install ${NAS_ENCRYPTOR_RPM_FILE} ... "
rpm -ihv ${NAS_ENCRYPTOR_RPM_FILE}
[ $? -ne 0 ] && echo "Fail." && exit 1
echo "Pass."

####################
# Done.  Successful installation!
echo "NAS Encryptor Installation complete."
exit 0

