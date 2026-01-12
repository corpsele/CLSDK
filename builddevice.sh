# open ./scripts/hgmsdkios_device.app
#!/bin/bash

cd /Volumes/Seagate015_4T/projects/sdk_ios/HGMSDK.xcodeproj
wait
rm -rf project.pbxproj
wait
cp -R project_device.pbxproj project.pbxproj
wait
cd ..
wait
# $XCODE134
/Volumes/Seagate015_4T/mapapps/Xcode13.4.app/Contents/Developer/usr/bin/xcodebuild -scheme HGMSDK -workspace HGMSDK.xcworkspace -configuration Release -destination 'generic/platform=iOS' -derivedDataPath .
#armv7