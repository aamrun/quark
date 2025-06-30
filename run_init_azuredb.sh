# 1. [Creating Database Using Microsoft SQL Server](https://docs.tibco.com/pub/bpme/5.5.0/doc/html/installation/create-configure-the-tibco-bpm-enterprise-database-sql-server.htm)

scriptdir="$( dirname -- "$( readlink -f -- "$0"; )"; )"

docker run --name tmp_azuredb -itd --rm --network=560_default --mount type=bind,source="${scriptdir}",target=/var/tmp/dbscripts4bpme,readonly mcr.microsoft.com/azure-sql-edge:latest bash

docker exec -it tmp_azuredb opt/mssql-tools/bin/sqlcmd -S bpme-azuresqldb -U sa -P SysAdmin1! -d master -i //var/tmp/dbscripts4bpme/createuser.sql

docker stop tmp_azuredb

 

# 2. [Creating the TIBCO BPM Enterprise Schema](https://docs.tibco.com/pub/bpme/5.5.0/doc/html/installation/create-the-tibco-bpm-enterprise-schema.htm)

db_url=(-dbConfig url="jdbc:sqlserver://dbsrv:1433;databaseName=bpm;trustServerCertificate=true;" username="bpmuser" password="bpmuser")

docker run --name tmp_bpm_util -itd --rm --network=560_default abnamro2024/aamrun:bpme_utility_560 bash

docker exec -it tmp_bpm_util utility "${db_url[@]}" -setupDatabase execute # Create DB schema

docker stop tmp_bpm_util

 

docker restart bpme-app-1
