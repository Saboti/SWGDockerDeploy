#!/bin/bash

git config --global --add safe.directory /opt/Core3
git config --global --add safe.directory /opt/Core3/MMOCoreORB/utils/engine3
cd /opt/Core3/MMOCoreORB/;make -j $(nproc)
