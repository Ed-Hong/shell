#!/bin/zsh

echo "What is the current version number?"
read version

echo "What should the new version number be?"
read newVersion

echo "What is the current Android version code?"
read versionCode

echo "Updating version numbers..."
version="${version//./\.}"
newVersionCode=$((versionCode+1))

eval "sed -i \"\" 's/$version/$newVersion/g' /Users/ehong/source/repos/tabletApp/src/iOS/iOS.AppFolder/*.plist"
eval "sed -i \"\" 's/$version/$newVersion/g' /Users/ehong/source/repos/tabletApp/src/Droid/Droid.AppFolder/Properties/*.xml"
eval "sed -i \"\" 's/$versionCode/$newVersionCode/g' /Users/ehong/source/repos/tabletApp/src/Droid/Droid.AppFolder/Properties/*.xml"
eval "sed -i \"\" 's/$version/$newVersion/g' /Users/ehong/source/repos/devices/scripts/update-latest-version.sql"

eval "sed -i \"\" 's/$version/$newVersion/g' /Users/ehong/source/repos/devices/src/Devices.Api/appsettings.json"
eval "sed -i \"\" 's/$version/$newVersion/g' /Users/ehong/source/repos/devices/src/Devices.UnitTests/appsettings.json"

echo "Done."
