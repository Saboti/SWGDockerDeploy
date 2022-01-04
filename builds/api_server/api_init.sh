#!/bin/bash

cd /opt/api_server
dotnet build

touch /start_apiserver.sh

cat << EOF > /start_apiserver.sh
cd /opt/api_server/;
dotnet run
EOF

chmod +x /start_apiserver.sh

cat << EOF >> /etc/supervisor/supervisord.conf 
[program:apiserver]
command=/bin/bash /start_apiserver.sh
numprocs=1
autostart=true
autorestart=true
EOF

dbsecret=$1
dbpassword=$2
db_properties=$3

sed -i "s/swgemus3cr37!/$dbsecret/g" $db_properties
sed -i "s/123456/$dbpassword/g" $db_properties
sed -i "s/localhost/192.168.88.3/g" $db_properties

rm /api_init.sh
