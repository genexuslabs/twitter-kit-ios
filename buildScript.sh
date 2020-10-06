# PARAMETERS DEFAULTS
DEFAULT_BUILD_CONFIG="Release"
DEFAUILT_BUILD_COMMAND="build archive"
PLATFORM_NAMES=("iOS" "tvOS")
IOS_NAMES_SDKS=("iphonesimulator" "iphoneos")
TVOS_NAMES_SDKS=("appletvsimulator" "appletvos")
PROJECTS_NAMES=("TwitterCore" "TwitterKit")
BUILDS_FOR_TV=(true false) #Same order as PROJECTS_NAMES above. Indicates if tvOS SDKs should be used.

#FILES and FOLDERS
ROOT_FOLDER=$(pwd)
POD_DIRECTORY_NAME="Pod"
README_FILE_NAMES=("cocoapod_readme.md" "README.md") #Same order as PROJECTS_NAMES above.

#FUNCTIONS
function createOrCleanDirectory () {
    echo "Preparing directory... ('$1')"

    if [ -d "$1" ];
    then
        echo "Cleaning build directory"
        rm -rf $1/*
    else
        echo "Build directory does not exist. Creating it..."
        mkdir -p $1
    fi
}

function copyToOutputDirectory () {
    echo "Copying to output directory... (Output directory: $1)"

    FULL_PATH="$ROOT_FOLDER/$1"
    if [ -d "$FULL_PATH" ];
    then
        if [ -d $2 ];
        then
            cp -f -R $2/* $FULL_PATH
        else
            cp -f -R $2 $FULL_PATH
        fi
    else
        echo "Could not find output directory. Full path: $FULL_PATH"
        return 1
    fi
}

function getPodspecVersion () {
    PODSPEC_FILE=$1
    echo $(grep -hnr -m 1 "s.version" $PODSPEC_FILE | grep -o '".*"' | tr -d '"')
}

#BUILD TWITTERKIT
#for PROJECT_NAME in "${PROJECTS_NAMES[@]}"; do
for ((i = 0; i < ${#PROJECTS_NAMES[@]}; i++)); do
    PROJECT_NAME=${PROJECTS_NAMES[i]}
    echo "\033[1mBuilding $PROJECT_NAME\033[0m"

    XCODEPROJ_NAME="$ROOT_FOLDER/$PROJECT_NAME/$PROJECT_NAME.xcodeproj"
    SCHEME_NAME=$PROJECT_NAME
    CONFIG=$DEFAULT_BUILD_CONFIG
    POD_VERSION=$(getPodspecVersion "$ROOT_FOLDER/$PROJECT_NAME/GX$PROJECT_NAME.podspec")

    BUILT_FRAMEWORKS=()
    for PLATFORM in "${PLATFORM_NAMES[@]}"; do
        PROJECT_SYMROOT="$ROOT_FOLDER/$PROJECT_NAME/build/"
        if [ "$PLATFORM" == "tvOS" ];
        then
            if [ "${BUILDS_FOR_TV[i]}" = true ];
            then
                PLATFORMS_NAMES_SDKS=("${TVOS_NAMES_SDKS[@]}")
            else
                continue
            fi
        else
                PLATFORMS_NAMES_SDKS=("${IOS_NAMES_SDKS[@]}")
        fi

        echo "Building for platform: $PLATFORM"

        #BUILD FRAMEWORKS
        for SDK in "${PLATFORMS_NAMES_SDKS[@]}"; do
            CONFIG_SYMROOT="$PROJECT_SYMROOT/$CONFIG-$SDK"
            ARCHIVE_PATH="$PROJECT_SYMROOT/$PLATFORM_$SDK.xcarchive"
            
            if !(xcodebuild -project $XCODEPROJ_NAME -scheme $SCHEME_NAME -sdk $SDK -configuration $CONFIG BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO -quiet -archivePath $ARCHIVE_PATH $DEFAUILT_BUILD_COMMAND); 
            then
                echo "Bulding failed at dir: $CONFIG_SYMROOT"
                exit 1
            fi

            BUILT_FRAMEWORKS+=("$ARCHIVE_PATH/Products/Library/Frameworks/$SCHEME_NAME.framework")
        done
    done

    POD_OUTPUT_DIR="$PROJECT_NAME/$POD_DIRECTORY_NAME/$POD_VERSION"

    #CREATE XCFRAMEWORK
    echo "\033[1mCreating XCFramework\033[0m"

    XCFRAMEWORK_OUTPUT="$POD_OUTPUT_DIR/$PROJECT_NAME.xcframework"
    FRAMEWORKS=""
    for BUILT_FRAMEWORK in "${BUILT_FRAMEWORKS[@]}"
    do
        FRAMEWORKS+="-framework $BUILT_FRAMEWORK "
    done

    if !(xcodebuild -create-xcframework $FRAMEWORKS -output $XCFRAMEWORK_OUTPUT);
    then
        echo "Error building XCFramework for project $PROJECT_NAME"
    fi

    #COPY README FILE
    README_FILE="$ROOT_FOLDER/$PROJECT_NAME/${README_FILE_NAMES[i]}"
    copyToOutputDirectory $POD_OUTPUT_DIR $README_FILE

    #ZIP POD CONTENTS
    ZIP_FILE_NAME="$POD_OUTPUT_DIR/../$PROJECT_NAME.zip"
    echo "Creating zip file: $ZIP_FILE_NAME"

    ditto -c -k --sequesterRsrc $POD_OUTPUT_DIR $ZIP_FILE_NAME

    #CLEAN UP
    echo "Cleaning up Pod folder..."
    find "$POD_OUTPUT_DIR/.." -type f ! -name "*.zip" -delete #Files
    find "$POD_OUTPUT_DIR/.." -type d -delete #Folders
done
