#!/bin/sh

REALM="MIVEHIND.NET"
ADMINPASS="password"

hname="$1.mivehind.net"

rm /etc/krb5.keytab -rf || true
echo -e "$ADMINPASS\n$ADMINPASS" | kadmin -p "admin/admin@$REALM" addprinc -randkey host/$hname || true
echo -e "$ADMINPASS\n$ADMINPASS" | kadmin -p "admin/admin@$REALM" ktadd host/$hname || true
echo -e "$ADMINPASS\n$ADMINPASS" | kadmin -p "admin/admin@$REALM" addprinc -randkey nfs/$hname || true
echo -e "$ADMINPASS\n$ADMINPASS" | kadmin -p "admin/admin@$REALM" ktadd nfs/$hname || true
