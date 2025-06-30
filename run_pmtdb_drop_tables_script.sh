# 1. [Removing tables Using Microsoft SQL Server]

scriptdir="$( dirname -- "$( readlink -f -- "$0"; )"; )"

echo "Running from directory : "$scriptdir

docker run --name tmp_azuredb -itd --rm --network=560_default --mount type=bind,source="${scriptdir}",target=/var/tmp/dbscripts4pmt,readonly mcr.microsoft.com/azure-sql-edge:latest bash

echo "Dropping PMT DB objects"

docker exec -it tmp_azuredb opt/mssql-tools/bin/sqlcmd -S pmt-db -U pmtuser -P pmtuser -d pmtdb -i //var/tmp/dbscripts4pmt/drop_all_pmt_tables.sql

docker stop tmp_azuredb
