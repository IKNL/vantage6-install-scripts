echo "This script reschedules remote script fetching and executing every minute (e.g. 10:00 - 10:01 - 10.02 - ...)"
service cron stop
echo "CRON Service stopped"
echo "\nPrevious crontab file:\n"
cat /etc/crontab
sed -i 's/\*\/30 \* \* \* \* vantage_user/* * * * * vantage_user/' /etc/crontab
echo "\nNew crontab file:\n"
cat /etc/crontab
service cron start
echo "CRON Service started"