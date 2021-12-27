#!/bin/bash

docker exec -it zone_server /bin/bash /start_core3.sh
docker exec -it zone_server screen -r
