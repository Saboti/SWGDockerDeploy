#!/bin/bash

if [ ! -f "/etc/.firstrun" ]; then
    cd /opt/api_server
    dotnet build

    touch /opt/start_apiserver.sh

    cat << EOF > /opt/start_apiserver.sh
cd /opt/api_server/;
dotnet run
EOF

    chmod +x /opt/start_apiserver.sh

    cat << EOF >> /etc/supervisor/supervisord.conf 
[program:apiserver]
command=/bin/bash /opt/start_apiserver.sh
numprocs=1
autostart=true
autorestart=true
EOF

    dbsecret=$1
    db_properties=$2

    sed -i "s/swgemus3cr37!/$dbsecret/g" $db_properties
    sed -i "s/swgemu/$database/g" $db_properties

    touch /etc/.firstrun
fi
