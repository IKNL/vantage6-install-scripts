echo "Please enter your Site ID:"
read SITE_ID
export SITE_ID=$SITE_ID
echo "Site ID: $SITE_ID"

echo ""
echo "Please enter your REDCap Study ID:"
read STUDY_ID
export STUDY_ID=$STUDY_ID
echo "REDCap Study ID: $STUDY_ID"

echo ""
echo "Please enter your REDCap API URI:"
read API_URI
export API_URI=$API_URI
echo "REDCap API URI: $API_URI"

echo ""
echo "Please enter your REDCap API Token for study $STUDY_ID:"
read RC_TOKEN
export RC_TOKEN=$RC_TOKEN
echo "REDCap token: $RC_TOKEN"

ERROR="curl: (60) SSL certificate problem: unable to get local issuer certificate"
CHECK=$(curl $API_URI 2>&1 | grep "$ERROR")

if [ "$CHECK" = "$ERROR" ]; then
        echo ""
        echo "Please enter the path to REDCap URI chain certicate file (.crt extension):"
        echo "If you can't do this now, please skip the step by pressing ENTER and contact the support team."
        read CERTIFICATE_PATH
        export CERTIFICATE_PATH=$CERTIFICATE_PATH
        echo "Certificate Path: $CERTIFICATE_PATH"
        if [ -f "$CERTIFICATE_PATH" ]; then
            cp "$CERTIFICATE_PATH" /usr/local/share/ca-certificates/
            sudo update-ca-certificates
        fi
fi

BIOMDIR=$(dirname "$0")
#cp $BIOMDIR/proto_config.properties $BIOMDIR/config.properties
envsubst < $BIOMDIR/proto_config.properties > $BIOMDIR/config.properties
mv -f $BIOMDIR/config.properties /opt/redcap_dq/environment/config