#/bin/bash
#IPA_NAME=`find . -iname *.app`
#CRASHLYTICS=`find . -iname 'Crashlytics.framework'`
mkdir aw16app
find . -name 'AW16.app' -exec cp {} aw16app  \;
echo "copied"
zip -r aw16app.zip aw16app
mv aw16app.zip aw16app.ipa
