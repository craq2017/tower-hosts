#!/bin/bash

# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/httpd/* /tmp/httpd*
echo "SELECT date_part('year', created::date) as year, date_part('month', created::date) AS month, COUNT(name) FROM main_host GROUP BY year, month ORDER BY year, month; SELECT count (name) AS total FROM main_host; SELECT name,created FROM main_host;" | PGPASSWORD=admin psql -h tower.aq.lab -d awx -U awx -H > /var/www/html/index.html

exec /usr/sbin/apachectl -DFOREGROUND
