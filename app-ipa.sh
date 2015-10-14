#/bin/bash
IPA_NAME=`find . -iname *.app`
CRASHLYTICS=`find . -iname 'Crashlytics.framework'`
mkdir aw16app
cp -r $IPA_NAME aw16app
zip -r aw16app.zip aw16app
mv aw16app.zip aw16app.ipa