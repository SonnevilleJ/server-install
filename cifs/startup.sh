#!/bin/sh

if date > /home/plex/startup-time.txt ; then
	whoami >> /home/plex/startup-time.txt
	echo "Command succeeded"
else
	echo "Command failed"
fi

exit 0
