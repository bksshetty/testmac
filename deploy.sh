IPA_NAME=`find / -iname *.ipa`
CRASHLYTICS=`find / -iname 'Crashlytics.framework'`
if [ -f "$IPA_NAME" ] && [ -d "$CRASHLYTICS" ]; then
"$CRASHLYTICS/submit" $API_KEY $BUILD_SECRET -ipaPath "$IPA_NAME" -emails kirthanshetty@hotmail.com
else
echo "Error deploying ipa to crashlytics: no ipa or crashlytics framework found!";
exit 1
fi
