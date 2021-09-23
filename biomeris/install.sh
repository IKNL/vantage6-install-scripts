REPORT=biomeris-installation-report.txt
touch $REPORT

# Ubuntu 18.04 > bionic, chosen R release > cran35
sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu bionic-cran35/" >> /etc/apt/sources.list' 
# origin of this key: http://cran.rstudio.com/bin/linux/ubuntu/#get-5000-cran-packages tells about Michael Rutter and the fingerprint of the key
# looked it up in: https://keyserver.ubuntu.com/pks/lookup?search=michael+rutter&fingerprint=on&op=index > found: 51716619e084dab9 
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 51716619e084dab9 &>> $REPORT

echo "STEP 1/6"
echo "OS updating..."
sudo apt-get update &>> $REPORT
echo "...OS updated."

echo "STEP 2/6"
echo "R installing..."
sudo apt-get -y install r-base libapparmor1 libcurl4-gnutls-dev libxml2-dev libssl-dev gdebi-core &>> $REPORT
sudo apt-get -y install libcairo2-dev &>> $REPORT
sudo apt-get -y install libxt-dev &>> $REPORT
sudo apt-get -y install git-core &>> $REPORT

sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024 &>> $REPORT
sudo /sbin/mkswap /var/swap.1 &>> $REPORT
sudo /sbin/swapon /var/swap.1 &>> $REPORT
sudo sh -c 'echo "/var/swap.1 swap swap defaults 0 0 " >> /etc/fstab'
echo "...R installed."


echo "STEP 3/6"
echo "R packages installing..."
echo "this may take time"
#Devtools
sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\"" &>> $REPORT
echo "still in progress..."
#Packages needed by DQ scripts
sudo su - -c "R -e \"install.packages('REDCapR', repos='http://cran.rstudio.com/')\"" &>> $REPORT
echo "still in progress..."
sudo su - -c "R -e \"install.packages('plyr', repos='http://cran.rstudio.com/')\"" &>> $REPORT
echo "still in progress..."
sudo su - -c "R -e \"install.packages('dplyr', repos='http://cran.rstudio.com/')\"" &>> $REPORT
echo "still in progress..."
sudo su - -c "R -e \"install.packages('openxlsx', repos='http://cran.rstudio.com/')\"" &>> $REPORT
echo "still in progress..."
sudo su - -c "R -e \"install.packages('properties', repos='http://cran.rstudio.com/')\"" &>> $REPORT
echo "still in progress..."
sudo su - -c "R -e \"install.packages('prodlim', repos='http://cran.rstudio.com/')\"" &>> $REPORT
echo "still in progress..."
sudo su - -c "R -e \"install.packages('data.table', repos='http://cran.rstudio.com/')\"" &>> $REPORT
echo "still in progress..."
sudo su - -c "R -e \"install.packages('formattable', repos='http://cran.rstudio.com/')\"" &>> $REPORT
echo "still in progress..."
sudo su - -c "R -e \"install.packages('readtext', repos='http://cran.rstudio.com/')\"" &>> $REPORT
echo "...R packages installed."

echo "STEP 4/6"
echo "Environment setup..."
mkdir /opt/redcap_dq
mkdir /opt/redcap_dq/environment
mkdir /opt/redcap_dq/environment/config
mkdir /opt/redcap_dq/environment/data
mkdir /opt/redcap_dq/environment/logs
mkdir /opt/redcap_dq/environment/scripts
mkdir /opt/redcap_dq/environment/test

touch /opt/redcap_dq/environment/logs/log.txt
touch /opt/redcap_dq/environment/logs/history.txt

mkdir /opt/redcap_dq/engine
echo "...Environment ok"

echo "STEP 5/6"
echo "Cronjob setup..."
#transfer s3_get_R_run.sh to /opt/redcap_dq/engine
wget -q "https://biomeris-int-vantage-test.s3.eu-west-1.amazonaws.com/s3_get_R_run.sh" -P /opt/redcap_dq/engine > /dev/null &>> $REPORT

#cronjob: execute s3_get_R_run.sh every X (eg 5 mins)
echo "" >> /etc/crontab
echo "" >> /etc/crontab
echo "* * * * * root sh /opt/redcap_dq/engine/s3_get_R_run.sh" >> /etc/crontab
service cron restart &>> $REPORT
echo "Cronjob ok."

echo "STEP 6/6"
echo "Site DQ configuration..."
bash config.sh
echo "Site DQ configured"