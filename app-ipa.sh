#/bin/bash
#IPA_NAME=`find . -iname *.app`
#CRASHLYTICS=`find . -iname 'Crashlytics.framework'`
mkdir Payload
find . -name 'AW16.app' -exec cp {} Payload  \;
echo "copied"
ls Payload
zip -r aw16app.zip Payload
mv aw16app.zip aw16app.ipa
