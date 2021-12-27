#!/bin/bash

docker exec -it login_server /bin/bash /start_core3.sh
docker exec -it login_server screen -r
