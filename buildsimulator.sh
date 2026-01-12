#open ./scripts/hgmsdkios_simulator.app
#!/bin/bash

cd /Volumes/Seagate015_4T/projects/sdk_ios/HGMSDK.xcodeproj
wait
rm -rf project.pbxproj
wait
cp project_simulator.pbxproj project.pbxproj
wait
cd ..
wait
# 'platform=iOS Simulator,name=iPhone 13,OS=17.4'
# $XCODE134
/Volumes/Seagate015_4T/mapapps/Xcode13.4.app/Contents/Developer/usr/bin/xcodebuild -scheme HGMSDK -workspace HGMSDK.xcworkspace -configuration Release -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.2' -derivedDataPath .
#arm64 x86_64 i386