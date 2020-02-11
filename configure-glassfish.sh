#!/bin/bash

WORKDIR=`pwd`

newPassword=`dd if=/dev/urandom bs=1 count=1M 2> /dev/null | sha512sum | head -c 32`

cat<<eof > $WORKDIR/old_passwordfile.txt
AS_ADMIN_PASSWORD=
AS_ADMIN_NEWPASSWORD=$newPassword
eof

cat<<eof > $WORKDIR/new_passwordfile.txt
AS_ADMIN_PASSWORD=$newPassword
eof

cat<<eof > /var/lib/glassfish/initialAdminPassword
$newPassword
eof

asadmin start-domain domain1
asadmin --user admin --passwordfile $WORKDIR/old_passwordfile.txt change-admin-password
asadmin --user admin --passwordfile $WORKDIR/new_passwordfile.txt enable-secure-admin
asadmin stop-domain domain1

echo "Glassfish Admin Password"
echo ""
cat /var/lib/glassfish/initialAdminPassword
echo ""
echo "The initial Glassfish password can be found in the file /var/lib/glassfish/initialAdminPassword"
echo ""

