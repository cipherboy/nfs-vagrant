#!/bin/sh

REALM="NFS.TEST"
KDCPASS="secretes"
ADMINPASS="$KDCPASS"

USER1NAME="rharwood"
USER1PASS="$KDCPASS"

USER2NAME="alex"
USER2PASS="password"

echo -e "$KDCPASS\n$KDCPASS" | kdb5_util create -r $REALM -s || true
echo -e "$ADMINPASS\n$ADMINPASS" | kadmin.local addprinc "admin/admin@$REALM" || true
echo -e "$USER1PASS\n$USER1PASS" | kadmin.local addprinc "$USER1NAME@$REALM" || true
echo -e "$USER2PASS\n$USER2PASS" | kadmin.local addprinc "$USER2NAME@$REALM" || true


systemctl enable krb5kdc || true
systemctl enable kadmin || true
systemctl start krb5kdc || true
systemctl start kadmin || true
systemctl restart krb5kdc || true
systemctl restart kadmin || true
