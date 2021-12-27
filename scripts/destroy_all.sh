docker stop api_server
docker stop web_server
docker stop database_server
docker stop login_server
docker stop zone_server
docker rm api_server
docker rm web_server
docker rm database_server
docker rm login_server
docker rm zone_server
docker rmi api_image
docker rmi web_image
docker rmi database_image
docker rmi login_image
docker rmi zone_image
sudo rm -rf ~/volumes/api/*
sudo rm -rf ~/volumes/web/*
sudo rm -rf ~/volumes/database/*
sudo rm -rf ~/volumes/login/*
sudo rm -rf ~/volumes/zone/*
