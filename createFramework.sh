UNIVERSAL_OUTPUTFOLDER=./build/
PROJECT_NAME=HGMSDK
BUILD_DIR=./build
BUILD_ROOT=./
PORJECT_DIR=./HGSDKTest_OC/
CONFIGURATION=Release
WORKSPACE_NAME=HGSDKTest_OC.xcworkspace
# PROJECT_NAME=HGSDKTest_OC.xcodeproj

# security unlock-keychain login.keychain
 
# 创建输出目录，并删除之前的framework文件
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
rm -rf "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework"


 
# 分别编译模拟器和真机的Framework
# xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"
 
# xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"
 
# 拷贝真机的framework到univer目录
#cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"
 
# 合并framework，输出最终的framework到build目录
#lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"

# xcodebuild -workspace ${PORJECT_DIR}${WORKSPACE_NAME} -scheme ${PROJECT_NAME} -configuration Release

# xcodebuild -workspace ${PORJECT_DIR}${WORKSPACE_NAME} -scheme ${PROJECT_NAME} -sdk iphoneos -configuration Release

# xcodebuild -project ${PORJECT_DIR}${PROJECT_NAME} -sdk iphoneos -configuration "Release"

# platform:iOS Simulator, id:C7555088-EC37-4977-AFF0-FA89FB53EE9E, OS:15.0, name:iPhone 13 Pro Max

# xcodebuild -showdestinations -scheme ${PROJECT_NAME}

# export BUILD_DIR=${BUILD_DIR}

# BUILD_DIR=./Build-command-line
DERIVED_DATA_DIR=${BUILD_DIR}/DevicedData
# CONFIGURATION_BUILD_DIR=${CONFIGURATION_BUILD_DIR}

xcodebuild clean -workspace ${PORJECT_DIR}${WORKSPACE_NAME} -scheme ${PROJECT_NAME} -configuration ${CONFIGURATION}

xcodebuild -workspace ${PORJECT_DIR}${WORKSPACE_NAME} \
-scheme ${PROJECT_NAME} \
-configuration ${CONFIGURATION} \
-destination "platform=iOS Simulator,name=iPhone 13 Pro Max" \
# -showBuildSettings \
# -IDECustomBuildProductsPath=${BUILD_DIR} \
# -derivedDataPath=${DERIVED_DATA_DIR} \
# -archivePath '${BUILD_DIR}/${PROJECT_NAME}.framework-iphonesimulator.xcarchive' \
# derivedDataPath=${BUILD_DIR} \
# IDEPackageSupportUseBuiltinSCM=YES \
SYMROOT=${BUILD_DIR} \
# CONFIGURATION_TEMP_DIR=${BUILD_DIR} \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
# CONFIGURATION_BUILD_DIR=${BUILD_DIR} \
# BUILD_DIR=${BUILD_DIR} \
# BUILD_ROOT=${BUILD_DIR}

# cp -R "${CONFIGURATION_BUILD_DIR}/${PROJECT_NAME}.framework" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework"