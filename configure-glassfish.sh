#!/bin/bash

WORKDIR=`pwd`

initial_passwd_file=/var/lib/glassfish/initialAdminPassword
old_passwd_file=$WORKDIR/old_passwordfile.txt
new_passwd_file=$WORKDIR/new_passwordfile.txt

if [ ! -e "$initial_passwd_file" ]
then
	newPassword=`dd if=/dev/urandom bs=1 count=1M 2> /dev/null | sha512sum | head -c 32`

	cat<<eof > $old_passwd_file
AS_ADMIN_PASSWORD=
AS_ADMIN_NEWPASSWORD=$newPassword
eof

	cat<<eof > $new_passwd_file
AS_ADMIN_PASSWORD=$newPassword
eof

	cat<<eof > $initial_passwd_file
$newPassword
eof

	if ! asadmin start-domain domain1
	then
		echo "Unable to start glassfish domain." 1>&2
		exit 1
	fi

	if ! asadmin --user admin --passwordfile $WORKDIR/old_passwordfile.txt change-admin-password
	then
		echo "Unable to change the default Glassfish password." 1>&2
		exit 1
	fi

	if ! asadmin --user admin --passwordfile $WORKDIR/new_passwordfile.txt enable-secure-admin
	then
		echo "Unable to enable Glassfish secure admin." 1>&2
		exit 1
	fi

	if ! asadmin stop-domain domain1
	then
		echo "Unable to stop the Glassfish domain." 1>&2
		exit 1
	fi

	if [ -e "$old_passwd_file" ]
	then
		rm $old_passwd_file
	fi

	if [ -e "$new_passwd_file" ]
	then
		rm $new_passwd_file
	fi

	echo ""
	echo "********************************************************************************"
	echo ""
	echo "The initial Glassfish password can be found in the file $initial_passwd_file"
	echo "Glassfish Admin Password"
	echo ""
	cat $initial_passwd_file
fi

echo ""
echo "********************************************************************************"
echo ""
echo "The initial Glassfish password can be found in the file $initial_passwd_file"
echo ""
echo "********************************************************************************"
echo ""

sleep 20

exec "$@"

