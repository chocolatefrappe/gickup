#!/usr/bin/dumb-init /bin/sh
# vim:sw=4:ts=4:et
set -ae

# If we are running gickup, make sure it executes as the proper user.
if [ "$1" = 'gickup' ]; then
	if [ -z "$SKIP_CHOWN" ]; then
		# If the data dir is bind mounted then chown it
		if [ "$(stat -c %u /data)" != "$(id -u git)" ]; then
			chown -R git:git /data
		fi
	fi
	if [ "$(id -u)" = '0' ]; then
	  set -- su-exec git "$@"
	fi
fi

exec "$@"
