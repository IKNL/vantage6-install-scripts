echo "This script reschedules remote script fetching and executing every 30 minutes (e.g. 10:00 - 10:30 - 11.00 - ...)"
service cron stop
echo "CRON Service stopped"
echo "\nPrevious crontab file:\n"
cat /etc/crontab
sed -i 's/\* \* \* \* \* vantage_user/*\/30 * * * * vantage_user/' /etc/crontab
echo "\nNew crontab file:\n"
cat /etc/crontab
service cron start
echo "CRON Service started"