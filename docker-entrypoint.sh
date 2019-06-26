#!/usr/bin/env bash
set -euo pipefail

if ! [ -e rose.p6 -a -e lib/Rose/Configuration.pm6 ]; then
	echo >&2 "Rose not found in $PWD - copying now..."
	if [ "$(ls -A)" ]; then
		echo >&2 "WARNING: $PWD is not empty - press Ctrl+C now if this is an error!"
		( set -x; ls -A; sleep 10 )
	fi
	tar cf - --one-file-system -C /usr/src/p6-rose-${ROSE_VERSION} . | tar xf -
	echo >&2 "Complete! Rose ${ROSE_VERSION} has been successfully copied to $PWD"
fi

exec "$@"
