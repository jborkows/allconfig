#!/usr/bin/env bash

hsdis_install() {
    set -euo pipefail

    if [[ -z "${JAVA_HOME:-}" ]]; then
        echo "ERROR: JAVA_HOME is not set. Make sure SDKMAN! or another JDK manager is loaded."
        return 1
    fi

    local ARCH
    ARCH=$(uname -m)
    local HSDIS_ARCH
    local LIBARCH
    case "$ARCH" in
        x86_64)
            HSDIS_ARCH="amd64"
            LIBARCH="amd64"
            ;;
        aarch64)
            HSDIS_ARCH="aarch64"
            LIBARCH="aarch64"
            ;;
        *)
            echo "ERROR: Unsupported architecture: $ARCH"
            return 1
            ;;
    esac

    local FEATURE_VERSION
    FEATURE_VERSION=$(java -version 2>&1 | awk -F'"' '/version/ {print $2}' | cut -d. -f1)
    local TAG="jdk-${FEATURE_VERSION}-ga"
    local OPENJDK_DIR="$HOME/programs/openjdk/${FEATURE_VERSION}"

    echo "Installing hsdis for Java ${FEATURE_VERSION} (${ARCH})"
    echo "JAVA_HOME=$JAVA_HOME"
    echo "OpenJDK source tag=$TAG"
    echo "OpenJDK source dir=$OPENJDK_DIR"

    # Install build dependencies
    if [[ ! -f /usr/include/bfd.h ]]; then
        echo "Installing build dependencies..."
        sudo apt-get update
        sudo apt-get install -y build-essential git autoconf file binutils-dev libcapstone-dev gperf bison flex zip unzip
    else
        echo "Build dependencies already installed"
    fi

    # Clone OpenJDK source
    if [[ ! -d "$OPENJDK_DIR/.git" ]]; then
        echo "Cloning OpenJDK ${FEATURE_VERSION} source..."
        mkdir -p "$OPENJDK_DIR"
        git clone --branch "$TAG" --depth 1 https://github.com/openjdk/jdk.git "$OPENJDK_DIR"
    else
        echo "OpenJDK source already cloned at $OPENJDK_DIR"
    fi

    # Build hsdis
    local HSDIS_SRC="$OPENJDK_DIR/src/utils/hsdis/binutils/hsdis-binutils.c"
    local HSDIS_INCLUDE="$OPENJDK_DIR/src/utils/hsdis"
    local TMP_LIB="/tmp/libhsdis-${HSDIS_ARCH}.so"

    echo "Building hsdis..."
    gcc -shared -fPIC -O2 \
        -DLIBARCH_${LIBARCH} -DBINUTILS_NEW_API \
        -I"$HSDIS_INCLUDE" \
        -I"$JAVA_HOME/include" \
        -I"$JAVA_HOME/include/linux" \
        -o "$TMP_LIB" \
        "$HSDIS_SRC" \
        -lbfd -lopcodes -lz -ldl

    # Install
    local TARGET="$JAVA_HOME/lib/hsdis-${HSDIS_ARCH}.so"
    if [[ -f "$TARGET" ]]; then
        mv "$TARGET" "${TARGET}.backup.$(date +%Y%m%d%H%M%S)"
    fi
    cp "$TMP_LIB" "$TARGET"
    chmod 644 "$TARGET"

    echo "Installed hsdis to $TARGET"

    # Verify
    echo "Verifying..."
    if java -XX:+UnlockDiagnosticVMOptions -XX:+PrintAssembly -version 2>&1 | grep -q "Loading hsdis library failed"; then
        echo "ERROR: hsdis failed to load. Check dependencies with: ldd $TARGET"
        return 1
    fi

    echo "hsdis installed and verified successfully."
}

hsdis_install
