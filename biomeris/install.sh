sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list'
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install r-base libapparmor1 libcurl4-gnutls-dev libxml2-dev libssl-dev gdebi-core
sudo apt-get -y install libcairo2-dev
sudo apt-get -y install libxt-dev
sudo apt-get -y install git-core

sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1
sudo sh -c 'echo "/var/swap.1 swap swap defaults 0 0 " >> /etc/fstab'

sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('Rcpp', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('RcppEigen', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('ggplot2', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('Cairo', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('evaluate', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('formatR', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('highr', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('markdown', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('yaml', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('htmltools', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('knitr', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages('RColorBrewer', repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"source('http://bioconductor.org/biocLite.R'); biocLite('BiocParallel')\""
# sudo su - -c "R -e \"source('http://bioconductor.org/biocLite.R'); biocLite('Biobase')\""
# sudo su - -c "R -e \"source('http://bioconductor.org/biocLite.R'); biocLite('EBSeq')\""
# sudo su - -c "R -e \"source('http://bioconductor.org/biocLite.R'); biocLite('monocle')\""
# sudo su - -c "R -e \"source('http://bioconductor.org/biocLite.R'); biocLite('sincell')\""
# sudo su - -c "R -e \"source('http://bioconductor.org/biocLite.R'); biocLite('scde')\""
# sudo su - -c "R -e \"source('http://bioconductor.org/biocLite.R'); biocLite('scran')\""
# sudo su - -c "R -e \"source('http://bioconductor.org/biocLite.R'); biocLite('scater')\""
# sudo su - -c "R -e \"devtools::install_github('kdkorthauer/scDD')\""
# 
# wget https://download2.rstudio.org/rstudio-server-0.99.903-amd64.deb
# 
# sudo gdebi rstudio-server-0.99.903-amd64.deb

mkdir /opt/redcap_dq
mkdir /opt/redcap_dq/environment
mkdir /opt/redcap_dq/environment/data
mkdir /opt/redcap_dq/environment/logs
mkdir /opt/redcap_dq/environment/psets
mkdir /opt/redcap_dq/environment/reports
mkdir /opt/redcap_dq/environment/scripts
mkdir /opt/redcap_dq/environment/test

mkdir /opt/redcap_dq/engine

#transfer s3_get_R_run.sh to /opt/redcap_dq/engine
wget -q "https://biomeris-int-vantage-test.s3.eu-west-1.amazonaws.com/s3_get_R_run.sh" -P /opt/redcap_dq/engine > /dev/null

#cronjob: execute s3_get_R_run.sh every X (eg 5 mins)
echo "" >> /etc/crontab
echo "" >> /etc/crontab
echo "* * * * * root sh /opt/redcap_dq/engine/s3_get_R_run.sh" >> /etc/crontab
service cron restart

#TODO (maybe)
#-store an ENV variable which represents the site ID? (this may be used if we eant to (re)execute am R script only for a group of sites)
#-mechanism to execute scripts only once (within the "engine" or in the scripts themselves)