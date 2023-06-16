VERSION="1.2"
REPORT=biomeris-installation-report.txt
touch $REPORT

# Ubuntu 22.04 > jammy, chosen R release > cran40
#sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu jammy-cran40/" >> /etc/apt/sources.list' 
sudo sh -c 'echo "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" >> /etc/apt/sources.list' 
# origin of this key: http://cran.rstudio.com/bin/linux/ubuntu/#get-5000-cran-packages tells about Michael Rutter and the fingerprint of the key
# looked it up in: https://keyserver.ubuntu.com/pks/lookup?search=michael+rutter&fingerprint=on&op=index > found: 51716619e084dab9 
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 51716619e084dab9 &>> $REPORT

echo "STEP 1/7"
echo "OS updating..."
sudo apt-get update &>> $REPORT
echo "...OS updated."

echo "STEP 2/7"
echo "R installing..."
sudo apt-get -y install r-base libapparmor1 libcurl4-gnutls-dev libxml2-dev libssl-dev gdebi-core &>> $REPORT
sudo apt-get -y install libcairo2-dev &>> $REPORT
sudo apt-get -y install libxt-dev &>> $REPORT
sudo apt-get -y install git-core &>> $REPORT
sudo apt-get -y install curl &>> $REPORT

sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024 &>> $REPORT
sudo /sbin/mkswap /var/swap.1 &>> $REPORT
sudo /sbin/swapon /var/swap.1 &>> $REPORT
#sudo sh -c 'echo "/var/swap.1 swap swap defaults 0 0 " >> /etc/fstab'
echo "/var/swap.1 swap swap defaults 0 0 " >> /etc/fstab
echo "...R installed."


echo "STEP 3/7"
echo "R packages installing..."
echo "...this may take time..."

#Remotes
sudo su - -c "R -e \"install.packages('https://cran.r-project.org/src/contrib/Archive/remotes/remotes_2.4.1.tar.gz', repos = NULL, type = 'source', dependencies = TRUE)\"" &>> $REPORT

echo "...still in progress..."
#Packages needed by DQ scripts
sudo su - -c "R -e \"remotes::install_version('REDCapR', version = '1.0.0', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...still in progress..."
sudo su - -c "R -e \"remotes::install_version('plyr', version = '1.8.6', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...still in progress..."
sudo su - -c "R -e \"remotes::install_version('dplyr', version = '1.0.8', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...still in progress..."
sudo su - -c "R -e \"remotes::install_version('openxlsx', version = '4.2.4', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...still in progress..."
sudo su - -c "R -e \"remotes::install_version('properties', version = '0.0.9', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...still in progress..."
sudo su - -c "R -e \"remotes::install_version('prodlim', version = '2019.11.13', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...still in progress..."
sudo su - -c "R -e \"remotes::install_version('data.table', version = '1.14.2', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...still in progress..."
sudo su - -c "R -e \"remotes::install_version('formattable', version = '0.2.1', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...still in progress..."
sudo su - -c "R -e \"remotes::install_version('gtools', version = '3.9.2', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...still in progress..."
#sudo add-apt-repository -y ppa:cran/poppler &>> $REPORT
#sudo apt-get update &>> $REPORT
sudo apt-get install -y libpoppler-cpp-dev &>> $REPORT
sudo su - -c "R -e \"remotes::install_version('rjson', version = '0.2.20', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...still in progress..."
sudo su - -c "R -e \"remotes::install_version('readtext', version = '0.81', repos = 'https://cloud.r-project.org')\"" &>> $REPORT
echo "...R packages installed."

echo "STEP 4/7"
echo "Environment setup..."
mkdir /opt/redcap_dq
mkdir /opt/redcap_dq/environment
mkdir /opt/redcap_dq/environment/config
mkdir /opt/redcap_dq/environment/data
mkdir /opt/redcap_dq/environment/logs
mkdir /opt/redcap_dq/environment/scripts
mkdir -p /var/lib/docker/volumes/vantage6-starter_head_and_neck-user-vol/_data
mkdir -p /data
#mkdir /opt/redcap_dq/environment/test

touch /opt/redcap_dq/environment/logs/log.txt
touch /opt/redcap_dq/environment/logs/history.txt

mkdir /opt/redcap_dq/engine
echo "...Environment ok"

echo "STEP 5/7"
echo "Creting user vantage_user and giving permissions on working directories..."
sudo useradd -m vantage_user
sudo chown -R vantage_user:vantage_user /opt/redcap_dq/environment
# TODO: CHECK IF THESE CAN BE RESTRICTED
sudo chmod -R 777 /var/lib/docker/volumes/vantage6-starter_head_and_neck-user-vol/_data 
sudo chmod -R 777 /data
echo "...User ok"

echo "STEP 6/7"
echo "Cronjob setup..."

sudo groupadd docker
sudo usermod -aG docker vantage_user

#transfer s3_get_R_run.sh to /opt/redcap_dq/engine
wget -q "https://biomeris-int-vantage-test.s3.eu-west-1.amazonaws.com/s3_get_R_run.sh" -P /opt/redcap_dq/engine > /dev/null &>> $REPORT
sudo chown -R vantage_user:vantage_user /opt/redcap_dq/engine

#cronjob: execute s3_get_R_run.sh every X (eg 5 mins)
echo "" >> /etc/crontab
echo "" >> /etc/crontab
echo "* * * * * vantage_user sh /opt/redcap_dq/engine/s3_get_R_run.sh" >> /etc/crontab
service cron restart &>> $REPORT
echo "Cronjob ok."

echo $VERSION > /opt/redcap_dq/engine/version
echo $VERSION"\t\t"$(date) > /opt/redcap_dq/engine/version_history

echo "STEP 7/7"
echo "Site DQ configuration..."
BIOMDIR=$(dirname "$0")
bash $BIOMDIR/config.sh
echo "Site DQ configured"
echo ""
echo ""
