# Notes on NFS

## Enable Debug in GSSProxy

In /etc/gssproxy/gssproxy.conf: 

    debug_level = 3

## Enable debug in NFSd (server)

    rpcdebug -m nfsd -s proc

(logs to dmesg)

## Enable debug in NFS (client)

    rpcdebug -m nfs -s proc

(logs to dmesg)

## Common Errors

### Authorization Denied on Mount

Can you contact the kdc?

Are you using the correct sec parameter?
