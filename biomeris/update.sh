VERSION="1.2"
VERSION_FILE=/opt/redcap_dq/engine/version
VERSION_HISTORY_FILE=/opt/redcap_dq/engine/version_history

update10to11() 
{
    echo "R packages installing..."
    echo "...this may take time..."
    
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
    
}

update11to12()
{
    echo "Removing old s3_get_R_run.sh script"
    rm /opt/redcap_dq/engine/s3_get_R_run.sh &>> $REPORT

    echo "Downloading new s3_get_R_run.sh script"
    wget -q "https://biomeris-int-vantage-test.s3.eu-west-1.amazonaws.com/s3_get_R_run.sh" -P /opt/redcap_dq/engine > /dev/null &>> $REPORT
    sudo chown -R vantage_user:vantage_user /opt/redcap_dq/engine
}


if   grep -q "\b1.0\b" $VERSION_FILE; 
then
    REPORT=biomeris-installation-report_1.0-to-$VERSION.txt
    touch $REPORT

    update10to11
    update11to12

    echo "1.0\t\tNA"            >> $VERSION_HISTORY_FILE
    echo $VERSION"\t\t"$(date)  >> $VERSION_HISTORY_FILE
    echo $VERSION >  $VERSION_FILE
    
elif grep -q "\b1.1\b" $VERSION_FILE || grep -q "\b1.1_updated\b" $VERSION_FILE; 
    REPORT=biomeris-installation-report_1.1-to-$VERSION.txt
    touch $REPORT
    
    update11to12
    
    # fix for the already updated version
    if grep -q "\b1.1\b" $VERSION_FILE;
    then
        echo "1.1\t\tNA" >> $VERSION_HISTORY_FILE
    else
        echo "1.0\t\tNA" >> $VERSION_HISTORY_FILE
        echo "1.1\t\tNA" >> $VERSION_HISTORY_FILE
    fi

    echo $VERSION"\t\t"$(date) >> $VERSION_HISTORY_FILE
    echo $VERSION >  $VERSION_FILE

else
	echo "No update available"
fi
