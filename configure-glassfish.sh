#!/bin/bash

WORKDIR=`pwd`

asadmin start-domain domain1
asadmin --user admin --passwordfile $WORKDIR/old_passwordfile.txt change-admin-password
asadmin --user admin --passwordfile $WORKDIR/new_passwordfile.txt enable-secure-admin
asadmin stop-domain domain1

