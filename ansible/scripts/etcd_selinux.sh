#!/bin/bash

ausearch -c '(etcd)' --raw | audit2allow -M my-etcd
semodule -X 300 -i my-etcd.pp
restorecon -Rv /usr/local/bin/etcd
