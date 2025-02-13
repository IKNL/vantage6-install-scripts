#!/bin/bash

mkdir -p $HOME/v6-restart-log
chown -R $SUDO_USER: $HOME/v6-restart-log
echo "" >> /etc/crontab
echo "" >> /etc/crontab
echo "0 1 * * * $SUDO_USER bash $HOME/vantage6-install-scripts/stop-node.sh && echo \"\$(date '+\%Y-\%m-\%d \%H:\%M:\%S') - V6 Node stopped\" >> $HOME/v6-restart-log/vantage_node_restart.log" >> /etc/crontab
echo "1 1 * * * $SUDO_USER bash $HOME/vantage6-install-scripts/start-node.sh && echo \"\$(date '+\%Y-\%m-\%d \%H:\%M:\%S') - V6 Node started\" >> $HOME/v6-restart-log/vantage_node_restart.log" >> /etc/crontab
service cron restart

echo "send this to matteo.gabetta@biomeris.it:"
echo ""
cat /etc/crontab