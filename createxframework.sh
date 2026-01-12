global_path="/Users/eport2/Library/Developer/Xcode/DerivedData/HGSDKTest_OC-cmvvthnkgwevizbwnfrpjjfkfxdf/Build/Products/"
global_path1="./Build/Products/"
iphone_dir="Release-iphoneos/"
simulator_dir="Release-iphonesimulator/"
framework_name="HGMSDK.framework"
xcframework_name="HGMSDK.xcframework"
output_path="./build/"

rm -rf "$output_path$xcframework_name"

# xcodebuild
/Volumes/Seagate015_4T/mapapps/Xcode13.4.app/Contents/Developer/usr/bin/xcodebuild -create-xcframework \
-framework "$global_path1$simulator_dir$framework_name" \
-framework "$global_path1$iphone_dir$framework_name" \
-output "$output_path$xcframework_name"

open "$output_path"