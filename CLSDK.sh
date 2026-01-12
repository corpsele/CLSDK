lib_name="HGMSDK"
output="docs"
swift_doc="$output/$lib_name-swift-doc.json"
objc_doc="$output/$lib_name-objc-doc.json"

lib_path="/Users/eport2/Documents/HGMSDK_iOS/HGMSDK"
umbrella_header="$lib_path/$lib_name.h"
sdk_path=`xcrun --show-sdk-path --sdk iphonesimulator`

# sourcekitten doc --objc $umbrella_header -- -x objective-c -isysroot $sdk_path -I $lib_path -fmodules > $objc_doc
# sourcekitten doc -- -project $lib_name.xcodeproj -target $lib_name > $swift_doc
# sourcekitten doc -- -workspace $lib_name.xcworkspace -scheme HGSDKTest_OC > docs/swiftDoc.json
# sourcekitten doc -- -workspace HGMSDK.xcworkspace -scheme HGMSDK
# appledoc -o ./docs --project-name HGMSDK --project-company customs ./
# appledoc --no-create-docset --output ./doc --ignore ./HGSDKTest_OC --ignore ./HGMSDK/NHGBridge_OC --ignore ./HGMSDK/dsbridge --include /Users/eport2/Library/Developer/Xcode/DerivedData/HGSDKTest_OC-cmvvthnkgwevizbwnfrpjjfkfxdf/Build/Products/Release-iphoneos/HGMSDK.framework/Headers/HGMSDK-Swift.h --project-name HGMSDK --project-company cn.gov.customs.HGMSDK ./
jazzy --author cn.gov.customs --include ./HGMSDK/NHGBridge_Swift/NHGWebView.swift --min-acl internal

