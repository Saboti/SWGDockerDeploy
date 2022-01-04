screen -wipe

screen -dmS core3

screen -S core3 -p 0 -X stuff ". ~/.bashrc^M"

screen -S core3 -p 0 -X stuff "cd /opt/Core3/MMOCoreORB/bin^M"

screen -S core3 -p 0 -X stuff "gdb -ex run core3 reloadstrings^M"
