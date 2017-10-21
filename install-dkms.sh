#!/bin/bash

# Script to add the driver to dkms
# Only basic functionality, upgrading a driver
# is not implemented so far.

# Check for root permission
if [ ! $UID -eq 0 ]; then
        echo 'This script requires to be run as root. Exiting...'
        exit 1
fi

# Check for dkms installed
if ! command -v dkms 2>&1 >/dev/null; then
        echo 'DKMS needs to be installed. Exiting...'
        exit 1
fi

# Get driver information from dkms.conf
source dkms.conf

echo "Copying the driver files to /usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}..."

# Check whether the target directory already exists
if [ -d "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}" ]; then
        echo "Target directory already exists. Delete? (y/n)"
        read RESPONSE
        if [ "$RESPONSE" == "y" ]; then
                rm -r "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"
        else
                echo "Exiting..."
                exit
        fi
fi

cp -r "$(dirname $0)" "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"

echo "Done!"
 

echo "Adding driver to dkms..."
dkms add -m "${PACKAGE_NAME}" -v "${PACKAGE_VERSION}"        
dkms build -m "${PACKAGE_NAME}" -v "${PACKAGE_VERSION}"        
dkms install -m "${PACKAGE_NAME}" -v "${PACKAGE_VERSION}"        
echo "Finished!"
