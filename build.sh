#!/bin/bash

if [ ! -f /opt/.firstrun ]; then
	count=$(ls tre/*.tre 2>/dev/null | wc -l)

	if [ $count -lt 1 ]; then
	    echo "You do not have any tre files in the tre directory..."
	    echo "Please add your tre files and edit the tre_list.lua config and try again."
	    exit 1
	fi

	# Change
	core3_repo=https://github.com/swgemu/Core3.git
	api_repo=https://github.com/SWGApps/LauncherAPI.git 
	fileserv_url=
	external_ip=

	# Do not change
	login_conf=~/volumes/login/Core3/MMOCoreORB/bin/conf/config.lua
	zone_conf=~/volumes/zone/Core3/MMOCoreORB/bin/conf/config.lua

	mkdir -p ~/volumes/web
	mkdir ~/volumes/web/status
	cp builds/web/main.py ~/volumes/web/status/main.py

	docker compose up -d

	echo "Allowing time for containers to start..."

	sleep 5

	sudo chown -R 1000:1000 ~/volumes

	sudo apt-get install git rsync python3 -y

	git clone $api_repo ~/volumes/api/api_server

	git clone $core3_repo ~/volumes/zone/Core3/

	# Build the zone server
	echo "Build zone Server"
	docker exec -it zone_server /bin/bash /build.sh

	mkdir ~/volumes/zone/tre
	mkdir ~/volumes/login/tre

	rsync --progress -av tre/* ~/volumes/zone/tre/
	rsync --progress -av tre/* ~/volumes/login/tre/

	db_secret=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 20 | head -n 1)
	db_password=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 20 | head -n 1)
	api_db_properties=/opt/api_server/Models/Properties/DatabaseProperties.cs

        echo "api init"
	docker exec -it api_server /bin/bash /api_init.sh $db_secret $db_password $api_db_properties

        # Copy zone server to login
        echo "copy zone server to login"
        rsync -av ~/volumes/zone/Core3 ~/volumes/login/

        echo "build login server"
	docker exec -it login_server /bin/bash /build.sh

	python3 scripts/replace_tre_list.py

	sed -i "s/127.0.0.1/192.168.88.3/g" $zone_conf
	sed -i "s/swgemus3cr37!/$db_secret/g" $zone_conf
	sed -i "s/123456/$db_password/g" $zone_conf

        sed -i "s/127.0.0.1/192.168.88.3/g" $login_conf
        sed -i "s/swgemus3cr37!/$db_secret/g" $login_conf
        sed -i "s/123456/$db_password/g" $login_conf

	sed -i "s/\/home\/swgemu\/Desktop\/SWGEmu/\/opt\/tre/g" $zone_conf
	sed -i "s/\/home\/swgemu\/Desktop\/SWGEmu/\/opt\/tre/g" $login_conf

	sed -i "s/MakeLogin = 1/MakeLogin = 0/g" $zone_conf
	sed -i "s/MakeZone = 1/MakeZone = 0/g" $login_conf
	sed -i "s/MakePing = 1/MakePing = 0/g" $login_conf
	sed -i "s/MakeStatus = 1/MakeStatus = 0/g" $login_conf

	cp builds/web/fileserv.conf ~/volumes/web_conf/
	sed -i "s/example.domain.com/$fileserv_url/g" ~/volumes/web_conf/fileserv.conf

	cp ~/volumes/zone/Core3/MMOCoreORB/sql/swgemu.sql ~/volumes/database/
	cp ~/volumes/api/api_server/sql/swgemu.sql ~/volumes/database/swgemu_append.sql

	docker exec -it database_server mysql -e "create database swgemu"
	# API server
	docker exec -it database_server mysql -e "create user 'swgemu'@'192.168.88.2' identified by '$db_password'"
	docker exec -it database_server mysql -e "grant all on swgemu.* to 'swgemu'@'192.168.88.2'"
	# Login server
	docker exec -it database_server mysql -e "create user 'swgemu'@'192.168.88.5' identified by '$db_password'"
	docker exec -it database_server mysql -e "grant all on swgemu.* to 'swgemu'@'192.168.88.5'"
	# Zone server
	docker exec -it database_server mysql -e "create user 'swgemu'@'192.168.88.6' identified by '$db_password'"
	docker exec -it database_server mysql -e "grant all on swgemu.* to 'swgemu'@'192.168.88.6'"

	docker exec -it database_server /bin/bash /import_db.sh $external_ip

	docker stop api_server
	docker start api_server
	docker stop web_server
	docker start web_server

	echo ""
	echo "Keep this information for your records:"
	echo "DB Secret: $db_secret"
	echo "DB Password: $db_password"

	cp -R scripts/ ~/.scripts/

	echo "" >> ~/.bashrc
	echo 'alias start_login="~/.scripts/start_login.sh"' >> ~/.bashrc
	echo 'alias start_zone="~/.scripts/start_zone.sh"' >> ~/.bashrc
	echo 'alias attach_login="~/.scripts/attach_login.sh"' >> ~/.bashrc
	echo 'alias attach_zone="~/.scripts/attach_zone.sh"' >> ~/.bashrc
	echo 'alias attach_api="~/.scripts/attach_api.sh"' >> ~/.bashrc
	source ~/.bashrc

	sudo touch /opt/.firstrun
else
	echo "Setup has already been ran!"
	echo "Delete /opt/.firstrun if you really want to run this script again."
fi
