#!/bin/sh

REALM="MIVEHIND.NET"
KDCPASS="password"
ADMINPASS="$KDCPASS"

USER1NAME="robbie"
USER1PASS="$KDCPASS"

USER2NAME="alex"
USER2PASS="$KDCPASS"

echo -e "$KDCPASS\n$KDCPASS" | kdb5_util create -r $REALM -s || true
echo -e "$ADMINPASS\n$ADMINPASS" | kadmin.local addprinc "admin/admin@$REALM" || true
echo -e "$USER1PASS\n$USER1PASS" | kadmin.local addprinc "$USER1NAME@$REALM" || true
echo -e "$USER2PASS\n$USER2PASS" | kadmin.local addprinc "$USER2NAME@$REALM" || true

killall kadmind -s 9 || true
killall krb5kdc -s 9 || true

krb5kdc || true
sleep 5
kadmind || true
