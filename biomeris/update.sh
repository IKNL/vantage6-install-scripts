if grep -q "1.0" /opt/redcap_dq/engine/version; then
    REPORT=biomeris-installation-report_1.0-to-1.1.txt
	touch $REPORT
    
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

    echo "1.1_updated" >> /opt/redcap_dq/engine/version
else
	echo "No update available"