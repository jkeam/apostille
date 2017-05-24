#!/usr/bin/env sh

# When run in the docker containers, the working directory
# is the root of the repo.
for DATABASE in ${DB_URL:-mysql://server@tcp(mysql:3306)/apostille} ${ROOT_DB_URL:-mysql://server_root@tcp(mysql:3306)/apostille_root}
do
		iter=0
		MIGRATIONS_PATH=${MIGRATIONS_PATH:-migrations/mysql}
		# have to poll for DB to come up
		until migrate -path=$MIGRATIONS_PATH -database=$DATABASE up
		do
			iter=$(( iter+1 ))
			if [[ $iter -gt 30 ]]; then
				echo "apostille database failed to come up within 30 seconds"
				exit 1;
			fi
			echo "waiting for $DATABASE to come up."
			sleep 1
		done
done
