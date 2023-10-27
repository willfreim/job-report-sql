mariadb --host=127.0.0.1 --user=will --database=unimusmdb --password --execute="SELECT \
  d.id AS \`Device ID\`, \
  z.name AS Zone, \
  d.vendor AS \`Vendor\`, \
  d.type AS \`Type\`, \
  d.model AS \`Model\`, \
  dhj.job_type AS \`Job type\`, \
  REPLACE(dhj.error_log, '\r\n', ' ') AS \`Error log\` \
FROM device d \
LEFT JOIN device_history_job dhj ON dhj.id = (\
  select id \
  from device_history_job \
  where d.id = device_id \
    and job_type = 'BACKUP' \
  order by create_time \
  desc limit 1) \
LEFT JOIN zone z ON z.id = d.zone_id \
WHERE dhj.successful = 0 \
  AND dhj.create_time > UNIX_TIMESTAMP(DATE_ADD(CURDATE(),INTERVAL -7 DAY))" > backup_local.csv
