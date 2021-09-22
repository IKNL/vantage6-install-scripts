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

cp proto_config.properties config.properties
envsubst < config.properties
mv config.properties /opt/redcap_dq/environment/config