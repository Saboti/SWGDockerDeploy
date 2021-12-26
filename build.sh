docker-compose up -d

echo "Allowing time for container to start..."

sleep 5

sudo cp builds/api_server/api_init.sh ~/volumes/api/

sudo apt-get install git -y

sudo git clone https://github.com/SWGApps/LauncherAPI.git ~/volumes/api/api_server

dbsecret=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 20 | head -n 1)
db_properties=/opt/api_server/Models/Properties/DatabaseProperties.cs

docker exec -it api_server /bin/bash /opt/api_init.sh $dbsecret $db_properties
# do database stuff here

docker stop api_server
docker start api_server
