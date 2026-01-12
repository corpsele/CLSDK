source_path="/Users/eport2/Documents/HGMSDK_iOS/HGMSDK"
sdk_name="HGMSDK"
# Generate Swift SourceKitten output
sourcekitten doc -- -workspace "$source_path/$sdk_name.xcworkspace" -scheme $sdk_name > swiftDoc.json

# Generate Objective-C SourceKitten output
sourcekitten doc --objc "$source_path/$sdk_name.h" \
      -- -x objective-c  -isysroot $(xcrun --show-sdk-path --sdk iphonesimulator) \
      -I $(pwd) -fmodules > objcDoc.json

# Feed both outputs to Jazzy as a comma-separated list
jazzy --sourcekitten-sourcefile swiftDoc.json,objcDoc.json