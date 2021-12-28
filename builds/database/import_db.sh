#!/bin/bash

mysql swgemu < /opt/swgemu.sql
mysql swgemu < /opt/swgemu_append.sql

mysql -e "use swgemu;update galaxy set address='$1' where galaxy_id='2';"
