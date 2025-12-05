#!/bin/bash
set -e

# Arguments
VERSION="$1"
NOTES="$2"
DOCKER_USER="$3"

if [ -z "$VERSION" ] || [ -z "$NOTES" ]; then
    echo "Usage: $0 <version> \"<release_notes>\" [docker_user]"
    echo "Example: $0 1.0.0 \"Initial Release\" j4ckgrey"
    exit 1
fi

# --- Helper Function: Inject PWA Prompt ---
inject_pwa_prompt() {
    local TARGET_DIR="${1:-.}"
    echo "   - Injecting PWA Prompt into $TARGET_DIR..."

    if [ ! -f "$TARGET_DIR/index.html" ]; then
        echo "Error: index.html not found in $TARGET_DIR"
        exit 1
    fi

    # Create pwa_prompt.js
    cat <<INNER_EOF > "$TARGET_DIR/pwa_prompt.js"
let deferredPrompt;

window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault();
  deferredPrompt = e;
  showInstallPromotion();
});

function showInstallPromotion() {
    if (window.matchMedia('(display-mode: standalone)').matches) {
        return;
    }

    const installButton = document.createElement('button');
    installButton.innerText = 'Install App';
    installButton.id = 'pwa-install-btn';
    
    Object.assign(installButton.style, {
        position: 'fixed',
        bottom: '30px',
        left: '50%',
        transform: 'translateX(-50%)',
        zIndex: '99999',
        padding: '12px 24px',
        backgroundColor: 'rgba(20, 20, 20, 0.6)',
        backdropFilter: 'blur(12px)',
        webkitBackdropFilter: 'blur(12px)',
        border: '1px solid rgba(255, 255, 255, 0.1)',
        borderRadius: '50px',
        color: 'white',
        fontSize: '16px',
        fontWeight: '600',
        cursor: 'pointer',
        boxShadow: '0 8px 32px 0 rgba(0, 0, 0, 0.37)',
        transition: 'all 0.3s ease',
        fontFamily: 'system-ui, -apple-system, sans-serif'
    });

    installButton.onmouseenter = () => {
        installButton.style.backgroundColor = 'rgba(20, 20, 20, 0.8)';
        installButton.style.transform = 'translateX(-50%) scale(1.05)';
    };
    installButton.onmouseleave = () => {
        installButton.style.backgroundColor = 'rgba(20, 20, 20, 0.6)';
        installButton.style.transform = 'translateX(-50%) scale(1)';
    };

    installButton.addEventListener('click', async () => {
        installButton.style.display = 'none';
        if (deferredPrompt) {
            deferredPrompt.prompt();
            const { outcome } = await deferredPrompt.userChoice;
            console.log(\`User response: \${outcome}\`);
            deferredPrompt = null;
        }
    });

    document.body.appendChild(installButton);
}

window.addEventListener('appinstalled', () => {
    const btn = document.getElementById('pwa-install-btn');
    if (btn) btn.style.display = 'none';
    console.log('PWA was installed');
});
INNER_EOF

    # Inject script tag
    if grep -q "pwa_prompt.js" "$TARGET_DIR/index.html"; then
        echo "     pwa_prompt.js already injected."
    else
        if grep -q "</body>" "$TARGET_DIR/index.html"; then
            sed -i 's|</body>|<script src="pwa_prompt.js"></script></body>|' "$TARGET_DIR/index.html"
            echo "     Injected script tag."
        else
            echo '<script src="pwa_prompt.js"></script>' >> "$TARGET_DIR/index.html"
            echo "     Appended script tag."
        fi
    fi
}

# --- Helper Function: Build Windows ---
build_windows() {
    echo "🪟 Building Windows..."
    
    # Configuration
    POWERSHELL_PATH="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
    ISCC_PATH="/mnt/c/Program Files (x86)/Inno Setup 6/ISCC.exe"
    BUILD_DIR="builds"
    TEMP_BUILD_DIR_WIN="C:\\Temp\\kebap_build_$(date +%s)"
    TEMP_BUILD_DIR_WSL="/mnt/c/Temp/kebap_build_$(date +%s)"

    # Check if tools exist
    if [ ! -f "$POWERSHELL_PATH" ]; then
        echo "Error: PowerShell not found at $POWERSHELL_PATH"
        return 1
    fi

    if [ ! -f "$ISCC_PATH" ]; then
        echo "Error: Inno Setup Compiler not found at $ISCC_PATH"
        echo "Please install Inno Setup 6."
        return 1
    fi

    # 1. Prepare Temporary Build Directory on Windows
    echo "   📂 Preparing temporary build directory: $TEMP_BUILD_DIR_WIN"
    mkdir -p "$TEMP_BUILD_DIR_WSL"

    # Copy source files
    echo "   🚚 Copying source files..."
    rsync -av --exclude 'build' --exclude 'builds' --exclude '.git' --exclude '.dart_tool' . "$TEMP_BUILD_DIR_WSL/"

    # 2. Clean and Build (64-bit)
    echo "   🧹 Cleaning and Building (x64)..."
    if ! "$POWERSHELL_PATH" -Command "cd '$TEMP_BUILD_DIR_WIN'; flutter clean; flutter pub get; flutter build windows --release"; then
        echo "   ❌ Build failed."
        echo "   💡 TIP: If you see 'Building with plugins requires symlink support', please enable Developer Mode on Windows."
        echo "      Go to Settings > Privacy & security > For developers > Developer Mode: ON"
        rm -rf "$TEMP_BUILD_DIR_WSL"
        return 1
    fi

    # 3. Create Installer using Inno Setup
    echo "   📦 Creating Installer..."
    ISS_FILE="$TEMP_BUILD_DIR_WIN\\windows\\windows_setup.iss"
    "$ISCC_PATH" "$ISS_FILE"

    # 4. Copy Artifacts Back
    echo "   🚚 Copying Artifacts back to WSL..."
    mkdir -p "$BUILD_DIR"

    POSSIBLE_OUTPUT_WSL="$TEMP_BUILD_DIR_WSL/windows/Output/kebap_setup.exe"
    POSSIBLE_OUTPUT_WSL_ALT="$TEMP_BUILD_DIR_WSL/windows/kebap_setup.exe"

    if [ -f "$POSSIBLE_OUTPUT_WSL" ]; then
        cp "$POSSIBLE_OUTPUT_WSL" "$BUILD_DIR/kebap_setup_x64.exe"
        echo "   ✅ Copied to $BUILD_DIR/kebap_setup_x64.exe"
    elif [ -f "$POSSIBLE_OUTPUT_WSL_ALT" ]; then
        cp "$POSSIBLE_OUTPUT_WSL_ALT" "$BUILD_DIR/kebap_setup_x64.exe"
        echo "   ✅ Copied to $BUILD_DIR/kebap_setup_x64.exe"
    else
        echo "   ⚠️ Could not locate generated installer in $TEMP_BUILD_DIR_WSL/windows/"
    fi

    # 5. Cleanup
    echo "   🧹 Cleaning up temporary directory..."
    rm -rf "$TEMP_BUILD_DIR_WSL"
}
# ------------------------------------------

echo "🚀 Starting Kebap Release Process for Version: $VERSION"

# 0. Update Version in pubspec.yaml
echo "📝 Updating pubspec.yaml version to $VERSION..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/^version: .*/version: $VERSION/" pubspec.yaml
else
  sed -i "s/^version: .*/version: $VERSION/" pubspec.yaml
fi

# 1. Clean (Preserve kebap-web)
echo "🧹 Cleaning project..."
flutter clean
if [ -d "builds" ]; then
    # Delete everything in builds EXCEPT kebap-web
    find builds -mindepth 1 -maxdepth 1 ! -name 'kebap-web' -exec rm -rf {} +
else
    mkdir -p builds
fi

# 2. Build Web
echo "🌐 Building Web..."
flutter build web --release --base-href "/"
# Inject PWA Prompt (Inline)
# inject_pwa_prompt build/web

# 3. Build Linux
echo "🐧 Building Linux (x64)..."
flutter build linux --release

# 4. Build Docker (Multi-arch)
echo "🐳 Building Docker Images..."
if ! docker buildx inspect kebap_builder > /dev/null 2>&1; then
    echo "Creating Docker builder..."
    docker buildx create --name kebap_builder --use
fi
docker buildx inspect --bootstrap

echo "   - Building AMD64..."
docker buildx build --platform linux/amd64 -t kebap:$VERSION-amd64 --load .
docker save -o builds/kebap-docker-$VERSION-amd64.tar kebap:$VERSION-amd64

echo "   - Building ARM64..."
docker buildx build --platform linux/arm64 -t kebap:$VERSION-arm64 --load .
docker save -o builds/kebap-docker-$VERSION-arm64.tar kebap:$VERSION-arm64

echo "   - Building ARMv7..."
docker buildx build --platform linux/arm/v7 -t kebap:$VERSION-armv7 --load .
docker save -o builds/kebap-docker-$VERSION-armv7.tar kebap:$VERSION-armv7

# Push to Docker Hub / GHCR if User Provided
if [ -n "$DOCKER_USER" ]; then
    echo "🚀 Pushing Docker Images for user: $DOCKER_USER"
    
    echo "   - Pushing to Docker Hub..."
    for ARCH in amd64 arm64 armv7; do
        docker tag kebap:$VERSION-$ARCH $DOCKER_USER/kebap:$VERSION-$ARCH
        docker push $DOCKER_USER/kebap:$VERSION-$ARCH
    done
    echo "   - Creating Docker Hub Manifest..."
    docker manifest create $DOCKER_USER/kebap:$VERSION \
        $DOCKER_USER/kebap:$VERSION-amd64 \
        $DOCKER_USER/kebap:$VERSION-arm64 \
        $DOCKER_USER/kebap:$VERSION-armv7 \
        --amend
    docker manifest push $DOCKER_USER/kebap:$VERSION

    echo "   - Pushing to GHCR..."
    # Login to GHCR using provided PAT
    echo "$GH_TOKEN" | docker login ghcr.io -u j4ckgrey --password-stdin

    GHCR_IMAGE="ghcr.io/$DOCKER_USER/kebap"
    for ARCH in amd64 arm64 armv7; do
        docker tag kebap:$VERSION-$ARCH $GHCR_IMAGE:$VERSION-$ARCH
        docker push $GHCR_IMAGE:$VERSION-$ARCH
    done
    echo "   - Creating GHCR Manifest..."
    docker manifest create $GHCR_IMAGE:$VERSION \
        $GHCR_IMAGE:$VERSION-amd64 \
        $GHCR_IMAGE:$VERSION-arm64 \
        $GHCR_IMAGE:$VERSION-armv7 \
        --amend
    docker manifest push $GHCR_IMAGE:$VERSION
    
    echo "✅ Docker Images Published!"
else
    echo "⚠️ No Docker User provided. Skipping Docker Push."
    echo "   To push images, run: $0 <version> \"<notes>\" <docker_user>"
fi

# 5. Build Android
echo "🤖 Building Android (APK)..."
flutter build apk --release --flavor production --split-per-abi

echo "   - Signing APKs..."
APKSIGNER=$(command -v apksigner || true)
if [ -z "$APKSIGNER" ]; then
    APKSIGNER=$(ls "$ANDROID_SDK_ROOT"/build-tools/*/apksigner 2>/dev/null | head -n1 || true)
fi

if [ -z "$APKSIGNER" ]; then
    echo "⚠️ apksigner not found; skipping signing."
else
    for apk in build/app/outputs/flutter-apk/*.apk; do
        if [[ "$apk" == *"-signed.apk" ]]; then continue; fi
        filename=$(basename "$apk")
        out="builds/${filename%.apk}-signed.apk"
        echo "   - Signing $filename -> $out"
        "$APKSIGNER" sign --ks android/app/keystore.jks \
            --ks-pass pass:kebap_temp_pw_2025 \
            --ks-key-alias kebap_release \
            --key-pass pass:kebap_temp_pw_2025 \
            --out "$out" "$apk"
        "$APKSIGNER" verify --print-certs "$out"
    done
fi

# 6. Build Windows (Inline)
build_windows

# 8. Package Artifacts
echo "📦 Packaging Remaining Artifacts..."
zip -r builds/kebap-linux-$VERSION.zip build/linux/x64/release/bundle

# Deb
mkdir -p builds/deb/DEBIAN
mkdir -p builds/deb/opt/kebap
mkdir -p builds/deb/usr/share/applications
mkdir -p builds/deb/usr/share/icons/hicolor/scalable/apps
cat > builds/deb/DEBIAN/control << EOL
Package: kebap
Version: $VERSION
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Kebap Team <maintainer@example.com>
Description: A simple cross-platform Jellyfin client.
 Kebap is a modern, fast, and beautiful Jellyfin client.
EOL
cat > builds/deb/usr/share/applications/kebap.desktop << EOL
[Desktop Entry]
Name=Kebap
Comment=A simple cross-platform Jellyfin client
Exec=/opt/kebap/Kebap
Icon=kebap
Terminal=false
Type=Application
Categories=AudioVideo;Video;Player;
EOL
cp -r build/linux/x64/release/bundle/* builds/deb/opt/kebap/
cp icons/kebap_icon.svg builds/deb/usr/share/icons/hicolor/scalable/apps/kebap.svg
dpkg-deb --build builds/deb builds/kebap_${VERSION}_amd64.deb
rm -rf builds/deb

# Web Zip
zip -r builds/kebap-web-$VERSION.zip build/web

# 7. Verify Artifacts
echo "🔍 Verifying Artifacts..."
MISSING=0
check_artifact() {
    if ls $1 1> /dev/null 2>&1; then echo "   ✅ Found $1"; else echo "   ❌ Missing $1"; MISSING=1; fi
}
check_artifact "builds/kebap-linux-*.zip"
check_artifact "builds/kebap_*.deb"
check_artifact "builds/kebap_setup_x64.exe"
APK_COUNT=$(ls builds/*-signed.apk 2>/dev/null | wc -l)
if [ "$APK_COUNT" -ge 3 ]; then echo "   ✅ Found $APK_COUNT signed APKs"; else echo "   ❌ Found only $APK_COUNT signed APKs"; MISSING=1; fi

if [ "$MISSING" -eq 1 ]; then
    echo "❌ Artifact verification failed. Aborting release."
    exit 1
fi

# 9. Documentation
echo "📝 Generating Documentation..."
# README
cat > builds/README.md << EOL
# Kebap Release $VERSION

## Artifacts
- \`kebap-linux-$VERSION.zip\`: Linux executable bundle.
- \`kebap_${VERSION}_amd64.deb\`: Linux installer (.deb).
- \`kebap-web-$VERSION.zip\`: Web build (PWA).
- \`kebap-docker-$VERSION-*.tar\`: Docker images for AMD64, ARM64, ARMv7.
- \`app-*-signed.apk\`: Android APKs.
- \`kebap_setup_x64.exe\`: Windows Installer.
- \`web/\`: Unzipped web build for direct hosting.

## Docker Images
- **Docker Hub**: \`$DOCKER_USER/kebap:$VERSION\`
- **GHCR**: \`ghcr.io/$DOCKER_USER/kebap:$VERSION\`

## Instructions
(See previous README for installation instructions)
EOL

# 10. Git Release
echo "🐙 Pushing Source Code Release..."
git add .
git commit -m "Release $VERSION" || echo "Nothing to commit"
git tag -f "v$VERSION"
git push origin HEAD
git push -f origin "v$VERSION"

# 11. Web Repo Push (Persistent)
echo "🌐 Pushing Web Build to kebap-web..."
if [ -d "builds/kebap-web" ]; then
    echo "   - Updating existing repo..."
    # Clean old files but keep .git
    find builds/kebap-web -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
    # Copy new build
    cp -r build/web/* builds/kebap-web/
    # Commit and Push
    cd builds/kebap-web
    git add .
    git commit -m "Release $VERSION"
    git push origin master
    cd ../..
else
    echo "⚠️ 'builds/kebap-web' not found. Skipping web repo push."
    echo "   To enable this, clone your web repo into 'builds/kebap-web' before running this script."
fi

# 12. GitHub Release
if command -v gh &> /dev/null; then
    echo "🚀 Creating GitHub Release v$VERSION..."
    gh release create "v$VERSION" \
        --title "Kebap $VERSION" \
        --notes "$NOTES" \
        builds/kebap-linux-*.zip \
        builds/kebap_*.deb \
        builds/kebap-web-*.zip \
        builds/*-signed.apk \
        builds/kebap_setup_x64.exe
else
    echo "⚠️ 'gh' CLI not found. Please upload artifacts manually."
fi

echo "✅ Release Process Complete!"
