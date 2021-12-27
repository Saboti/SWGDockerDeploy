#!/bin/bash

cat << EOF >> /etc/supervisor/supervisord.conf
[program:core3]
command=/bin/bash /start_core3.sh
numprocs=1
autostart=true
autorestart=false
EOF

rm /zone_init.sh
